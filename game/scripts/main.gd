extends Node2D

const PLAYER_SCENE := preload("res://scripts/player.gd")
const WORLD_SCENE := preload("res://scripts/world_tiles.gd")
const UI_SCENE := preload("res://scripts/ui.gd")
const STATE_SCENE := preload("res://scripts/game_state.gd")
const SAVE_SCENE := preload("res://scripts/save_system.gd")
const WEATHER_SCENE := preload("res://scripts/weather.gd")
const GATHER_SCENE := preload("res://scripts/gather_node.gd")
const AUDIO_SCENE := preload("res://scripts/audio.gd")
const PROPS := preload("res://assets/props.svg")

var world: Node2D
var player: CharacterBody2D
var ui: CanvasLayer
var state: Node
var save_system: Node
var weather: Node
var audio: Node
var prompt := ""
var toast := ""
var toast_time := 0.0
var echo_cooldown := 0.0
var fish_cooldown := 0.0
var nearby_kind := ""
var nearby_id := ""
var vfx_root: Node2D
var interactables := [
	{"id":"mara", "kind":"npc", "pos":Vector2(300,250), "radius":34.0},
	{"id":"rowan", "kind":"npc", "pos":Vector2(620,250), "radius":34.0},
	{"id":"old_road", "kind":"echo", "pos":Vector2(495,355), "radius":42.0},
	{"id":"glass_orchard", "kind":"echo", "pos":Vector2(520,150), "radius":42.0},
	{"id":"fishing", "kind":"fish", "pos":Vector2(730,370), "radius":58.0},
	{"id":"home", "kind":"home", "pos":Vector2(430,235), "radius":48.0}
]

func _ready() -> void:
	state = STATE_SCENE.new()
	add_child(state)
	save_system = SAVE_SCENE.new()
	add_child(save_system)
	world = WORLD_SCENE.new()
	world.name = "LarkmereValley"
	add_child(world)
	vfx_root = Node2D.new()
	vfx_root.name = "VFX"
	vfx_root.z_index = 40
	add_child(vfx_root)
	_spawn_gather_nodes()
	_add_orchard_echo_visual()
	weather = WEATHER_SCENE.new()
	add_child(weather)
	audio = AUDIO_SCENE.new()
	add_child(audio)
	player = PLAYER_SCENE.new()
	player.name = "Wayfarer"
	player.position = Vector2(480, 290)
	add_child(player)
	player.state = state
	ui = UI_SCENE.new()
	ui.name = "HUD"
	add_child(ui)
	ui.state = state
	ui.creation_finished.connect(_on_creation_finished)
	ui.sound_requested.connect(_play_cue)
	_load_if_present()
	player.set_physics_process(not String(state.character.get("name","")).is_empty())
	weather.set_weather(state.weather)
	_show_toast("Welcome to Larkmere Valley.")
	queue_redraw()

func _spawn_gather_nodes() -> void:
	for data in [
		{"id":"wood_1","resource":"wood","index":0,"pos":Vector2(205,150)},
		{"id":"wood_2","resource":"wood","index":0,"pos":Vector2(760,165)},
		{"id":"wood_3","resource":"wood","index":0,"pos":Vector2(155,92)},
		{"id":"stone_1","resource":"stone","index":8,"pos":Vector2(180,360)},
		{"id":"stone_2","resource":"stone","index":8,"pos":Vector2(820,330)}
	]:
		var node := GATHER_SCENE.new()
		node.name = String(data.id)
		node.setup(String(data.resource), PROPS, int(data.index), data.pos)
		node.harvested.connect(_on_gathered)
		world.add_child(node)

func _add_orchard_echo_visual() -> void:
	var s := Sprite2D.new()
	s.texture = PROPS
	s.region_enabled = true
	s.region_rect = Rect2(6 * 32, 0, 32, 32)
	s.position = Vector2(520,150)
	s.scale = Vector2(1.15,1.15)
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.z_index = 3
	world.add_child(s)

func _on_gathered(node: Node) -> void:
	state.add_item(node.resource_id, node.amount)
	_play_cue("gather")
	state.add_xp(4)
	_show_toast("Gathered %s +%d  •  node will regrow." % [node.resource_id.capitalize(), node.amount])

func _process(delta: float) -> void:
	echo_cooldown = maxf(0.0, echo_cooldown - delta)
	fish_cooldown = maxf(0.0, fish_cooldown - delta)
	toast_time = maxf(0.0, toast_time - delta)
	_update_nearby()
	if weather:
		weather.follow_player(player)
		weather.set_time(state.hour)
	if ui:
		ui.set_prompt(prompt, toast if toast_time > 0.0 else "")
	queue_redraw()

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
	for node in get_tree().get_nodes_in_group("gather_nodes"):
		if node.can_gather():
			var distance: float = player.position.distance_to(node.global_position)
			if distance < 34.0 and distance < nearest:
				nearest = distance
				nearby_kind = "gather"
				nearby_id = node.resource_id
	if nearby_kind == "":
		prompt = "WASD / Arrows move  •  E interact  •  I inventory  •  K save"
	else:
		match nearby_kind:
			"npc": prompt = "E  Talk"
			"echo": prompt = "E  Listen to the Echo"
			"fish": prompt = "E  Fish"
			"home": prompt = "E  Rest at home"
			"gather": prompt = "E  Gather " + nearby_id

func _interact() -> void:
	match nearby_kind:
		"npc": _talk(nearby_id)
		"echo": _discover_echo(nearby_id)
		"fish": _fish()
		"home": _rest()
		"gather":
			for node in get_tree().get_nodes_in_group("gather_nodes"):
				if node.resource_id == nearby_id and node.global_position.distance_to(player.position) < 34.0:
					node.gather()
					break

func _talk(id: String) -> void:
	if id == "mara":
		if state.flags.get("old_road_echo", false) and not state.flags.get("mara_echo_return", false):
			state.set_flag("mara_echo_return", true)
			state.add_xp(30)
			ui.show_dialogue("Mara Vale", "You heard it. I can tell. The valley has been waiting for someone willing to listen.")
			_show_toast("Quest advanced  •  Mara trusts you with the next Echo.")
		else:
			ui.show_dialogue("Mara Vale", "The river remembers every footstep. Most people just don't listen anymore.")
		state.set_flag("met_mara", true)
	elif id == "rowan":
		ui.show_dialogue("Rowan Bell", "Old road-stones are memory anchors. Find one, stand still, and let the world speak first.")
		state.set_flag("met_rowan", true)

func _discover_echo(id: String) -> void:
	if echo_cooldown > 0.0:
		return
	echo_cooldown = 1.5
	if id == "old_road":
		if state.flags.get("old_road_echo", false):
			ui.show_dialogue("The Old Road", "The road remembers you now.")
			return
		state.set_flag("old_road_echo", true)
		state.echoes += 1
		state.add_xp(25)
		state.add_item("memory_shard", 1)
		_play_cue("echo")
		_spawn_echo_burst(Vector2(495,355))
		ui.show_dialogue("An Echo", "A hundred travellers crossed this road before you. For a moment, you hear their laughter in the rain.")
		_show_toast("Echo I discovered  •  Memory Shard +1  •  XP +25")
	elif id == "glass_orchard":
		if not state.flags.get("old_road_echo", false):
			ui.show_dialogue("The Glass Orchard", "The stone is silent. Perhaps another memory must be awakened first.")
			return
		if state.flags.get("glass_orchard_echo", false):
			ui.show_dialogue("The Orchard", "Petals drift where no wind blows. Something here remembers spring.")
			return
		state.set_flag("glass_orchard_echo", true)
		state.echoes += 1
		state.add_xp(40)
		state.add_item("memory_shard", 1)
		_play_cue("echo")
		_spawn_echo_burst(Vector2(520,150))
		ui.show_dialogue("An Echo", "You remember a garden that once fed the whole valley. Somewhere beneath the roots, a bell is still ringing.")
		_show_toast("Echo II discovered  •  Memory Shard +1  •  XP +40")

func _fish() -> void:
	if fish_cooldown > 0.0:
		return
	fish_cooldown = 1.25
	state.add_item("river_fish", 1)
	_play_cue("fish")
	state.add_xp(6)
	_show_toast("You caught a silverfin.")

func _rest() -> void:
	state.energy = state.max_energy
	state.hp = state.max_hp
	state.advance_time(2)
	if state.hour >= 18 and state.hour < 21:
		state.weather = "Rain"
	else:
		state.weather = "Clear"
	weather.set_weather(state.weather)
	_show_toast("You rest at home. The valley feels a little quieter.")

func _attack() -> void:
	state.add_xp(1)
	_show_toast("A careful strike. Combat is optional here, but mastery will matter later.")

func _save_game() -> void:
	save_system.save_game(state, player)
	_show_toast("Game saved.")

func _load_game() -> void:
	if save_system.load_game(state, player):
		if player:
			player.refresh_customisation()
		weather.set_weather(state.weather)
		_show_toast("Game loaded.")
	else:
		_show_toast("No save found yet.")

func _load_if_present() -> void:
	if save_system.has_save():
		save_system.load_game(state, player)
		weather.set_weather(state.weather)

func _play_cue(kind: String) -> void:
	if audio:
		audio.cue(kind)

func _on_creation_finished() -> void:
	player.refresh_customisation()
	player.set_physics_process(true)
	_save_game()
	_show_toast("Welcome, %s." % state.character.name)

func _show_toast(message: String) -> void:
	toast = message
	toast_time = 3.0


func _spawn_sparkles(pos: Vector2) -> void:
	if vfx_root == null:
		return
	for i in range(6):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(0,-3),Vector2(2,0),Vector2(0,3),Vector2(-2,0)])
		p.color = Color("#ead49a")
		p.position = pos + Vector2(randf_range(-10,10), randf_range(-8,8))
		vfx_root.add_child(p)
		var tween := create_tween()
		tween.tween_property(p, "position:y", p.position.y - randf_range(10,24), 0.45)
		tween.parallel().tween_property(p, "modulate:a", 0.0, 0.45)
		tween.tween_callback(p.queue_free)

func _spawn_echo_burst(pos: Vector2) -> void:
	if vfx_root == null:
		return
	for i in range(10):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(0,-4),Vector2(2,0),Vector2(0,4),Vector2(-2,0)])
		p.color = Color("#d9c78c")
		p.position = pos
		vfx_root.add_child(p)
		var angle := TAU * float(i) / 10.0
		var target := pos + Vector2(cos(angle), sin(angle)) * 28.0
		var tween := create_tween()
		tween.tween_property(p, "position", target, 0.65)
		tween.parallel().tween_property(p, "modulate:a", 0.0, 0.65)
		tween.tween_callback(p.queue_free)
