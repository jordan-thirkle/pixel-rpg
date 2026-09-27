extends Node2D

const PLAYER_SCENE := preload("res://scripts/player.gd")
const WORLD_SCENE := preload("res://scripts/world.gd")
const UI_SCENE := preload("res://scripts/ui.gd")
const STATE_SCENE := preload("res://scripts/game_state.gd")
const SAVE_SCENE := preload("res://scripts/save_system.gd")

var world: Node2D
var player: CharacterBody2D
var ui: CanvasLayer
var state: Node
var save_system: Node
var prompt := ""
var toast := ""
var toast_time := 0.0
var echo_cooldown := 0.0
var fish_cooldown := 0.0
var nearby_kind := ""
var nearby_id := ""
var interactables := [
	{"id":"mara", "kind":"npc", "pos":Vector2(300,250), "radius":34.0},
	{"id":"rowan", "kind":"npc", "pos":Vector2(620,250), "radius":34.0},
	{"id":"old_road", "kind":"echo", "pos":Vector2(495,355), "radius":42.0},
	{"id":"fishing", "kind":"fish", "pos":Vector2(730,370), "radius":58.0},
	{"id":"home", "kind":"home", "pos":Vector2(430,235), "radius":48.0},
	{"id":"tree_1", "kind":"wood", "pos":Vector2(205,150), "radius":30.0},
	{"id":"tree_2", "kind":"wood", "pos":Vector2(760,165), "radius":30.0},
	{"id":"rock_1", "kind":"stone", "pos":Vector2(180,360), "radius":28.0},
	{"id":"rock_2", "kind":"stone", "pos":Vector2(820,330), "radius":28.0}
]

func _ready() -> void:
	state = STATE_SCENE.new()
	add_child(state)
	save_system = SAVE_SCENE.new()
	add_child(save_system)
	world = WORLD_SCENE.new()
	world.name = "LarkmereValley"
	add_child(world)
	player = PLAYER_SCENE.new()
	player.name = "Wayfarer"
	player.position = Vector2(480, 290)
	add_child(player)
	player.state = state
	ui = UI_SCENE.new()
	ui.name = "HUD"
	add_child(ui)
	ui.state = state
	_load_if_present()
	_show_toast("Welcome to Larkmere Valley.")
	queue_redraw()

func _process(delta: float) -> void:
	echo_cooldown = maxf(0.0, echo_cooldown - delta)
	fish_cooldown = maxf(0.0, fish_cooldown - delta)
	toast_time = maxf(0.0, toast_time - delta)
	_update_nearby()
	if ui:
		ui.set_prompt(prompt, toast if toast_time > 0.0 else "")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.keycode:
		KEY_E: _interact()
		KEY_I: ui.toggle_inventory()
		KEY_K: _save_game()
		KEY_L: _load_game()
		KEY_SPACE: _attack()
		KEY_ESCAPE: ui.close_panels()

func _update_nearby() -> void:
	nearby_kind = ""
	nearby_id = ""
	var nearest := 99999.0
	for item in interactables:
		var distance: float = player.position.distance_to(item.pos)
		if distance < item.radius and distance < nearest:
			nearest = distance
			nearby_kind = item.kind
			nearby_id = item.id
	if nearby_kind == "":
		prompt = "WASD / Arrows move  •  E interact  •  I inventory  •  K save"
	else:
		match nearby_kind:
			"npc": prompt = "E  Talk"
			"echo": prompt = "E  Listen to the Echo"
			"fish": prompt = "E  Fish"
			"home": prompt = "E  Rest at home"
			"wood": prompt = "E  Gather wood"
			"stone": prompt = "E  Gather stone"

func _interact() -> void:
	match nearby_kind:
		"npc": _talk(nearby_id)
		"echo": _discover_echo()
		"fish": _fish()
		"home": _rest()
		"wood":
			state.add_item("wood", 1)
			state.add_xp(3)
			_show_toast("Collected a piece of wood.")
		"stone":
			state.add_item("stone", 1)
			state.add_xp(3)
			_show_toast("Collected a piece of stone.")

func _talk(id: String) -> void:
	if id == "mara":
		ui.show_dialogue("Mara Vale", "The river remembers every footstep. Most people just don't listen anymore.")
		state.set_flag("met_mara", true)
	elif id == "rowan":
		ui.show_dialogue("Rowan Bell", "If you find old road-stones, don't polish them. Let the dust stay. That's where the Echoes hide.")
		state.set_flag("met_rowan", true)

func _discover_echo() -> void:
	if echo_cooldown > 0.0:
		return
	echo_cooldown = 1.5
	if state.flags.get("old_road_echo", false):
		ui.show_dialogue("The Old Road", "A familiar warmth lingers in the stone. The road remembers you now.")
		return
	state.set_flag("old_road_echo", true)
	state.echoes += 1
	state.add_xp(25)
	state.add_item("memory_shard", 1)
	ui.show_dialogue("An Echo", "A hundred travellers crossed this road before you. For a moment, you hear their laughter in the rain.")
	_show_toast("Echo discovered  •  Memory Shard +1  •  XP +25")

func _fish() -> void:
	if fish_cooldown > 0.0:
		return
	fish_cooldown = 1.25
	state.add_item("river_fish", 1)
	state.add_xp(6)
	_show_toast("You caught a silverfin.")

func _rest() -> void:
	state.energy = state.max_energy
	state.hp = state.max_hp
	state.advance_time(2)
	_show_toast("You rest at home. The valley feels a little quieter.")

func _attack() -> void:
	state.add_xp(1)
	_show_toast("The wayfarer practises a careful strike. Combat will grow from this foundation.")

func _save_game() -> void:
	save_system.save_game(state, player)
	_show_toast("Game saved.")

func _load_game() -> void:
	if save_system.load_game(state, player):
		_show_toast("Game loaded.")
	else:
		_show_toast("No save found yet.")

func _load_if_present() -> void:
	if save_system.has_save():
		save_system.load_game(state, player)

func _show_toast(message: String) -> void:
	toast = message
	toast_time = 3.0
