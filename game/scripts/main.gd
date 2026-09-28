extends Node2D

const PLAYER_SCENE := preload("res://scripts/player.gd")
const WORLD_SCENE := preload("res://scripts/world_tiles.gd")
const UI_SCENE := preload("res://scripts/ui.gd")
const STATE_SCENE := preload("res://scripts/game_state.gd")
const SAVE_SCENE := preload("res://scripts/save_system.gd")
const WEATHER_SCENE := preload("res://scripts/weather.gd")
const GATHER_SCENE := preload("res://scripts/gather_node.gd")
const AUDIO_SCENE := preload("res://scripts/audio.gd")
const ENEMY_SCENE := preload("res://scripts/enemy.gd")
const SETTINGS_SCENE := preload("res://scripts/settings.gd")
const CONTENT_SCENE := preload("res://scripts/content_registry.gd")
const INTERACTION_SCENE := preload("res://scripts/systems/interaction_system.gd")
const ECHO_SCENE := preload("res://scripts/systems/echo_system.gd")
const NPC_SCENE := preload("res://scripts/systems/npc_system.gd")
const GATHERING_SCENE := preload("res://scripts/systems/gathering_system.gd")
const COMBAT_SCENE := preload("res://scripts/systems/combat_system.gd")
const CRAFTING_SCENE := preload("res://scripts/systems/crafting_system.gd")
const LOCATION_SCENE := preload("res://scripts/systems/location_system.gd")
const FREEPLAY_SCENE := preload("res://scripts/systems/freeplay_system.gd")
const NPC_VISUAL_SCENE := preload("res://scripts/npc_visual.gd")

var world: Node2D
var player: CharacterBody2D
var ui: CanvasLayer
var state: Node
var settings: Node
var equipment_fx: Sprite2D
var save_system: Node
var weather: Node
var audio: Node
var registry: Node
var interactions: Node
var echoes: Node
var npcs: Node
var gathering: Node
var combat: Node
var crafting: Node
var location_system: Node
var freeplay: Node
var vfx_root: Node2D
var prompt := ""
var toast := ""
var toast_time := 0.0
var echo_cooldown := 0.0
var fish_cooldown := 0.0
var fish_phase := "idle"
var fish_timer := 0.0
var nearby_kind := ""
var nearby_id := ""
var session_started := false
var equipment_texture: Texture2D
var props_texture: Texture2D
var world_spawn_points := {
	"hearthfall": Vector2(480,290),
	"mara": Vector2(330,255),
	"old_road": Vector2(495,355),
	"fishing": Vector2(730,370),
	"glass_orchard": Vector2(520,150),
	"sleeping_gate": Vector2(820,430),
	"home": Vector2(300,300)
}

func _ready() -> void:
	equipment_texture = load("res://assets/hero_equipment.svg") as Texture2D
	props_texture = load("res://assets/props.svg") as Texture2D
	state = STATE_SCENE.new()
	state.name = "GameState"
	add_child(state)
	settings = SETTINGS_SCENE.new()
	settings.name = "Settings"
	add_child(settings)
	save_system = SAVE_SCENE.new()
	save_system.name = "SaveSystem"
	add_child(save_system)
	registry = CONTENT_SCENE.new()
	registry.name = "ContentRegistry"
	add_child(registry)
	interactions = INTERACTION_SCENE.new()
	interactions.name = "InteractionSystem"
	add_child(interactions)
	echoes = ECHO_SCENE.new()
	echoes.name = "EchoSystem"
	add_child(echoes)
	npcs = NPC_SCENE.new()
	npcs.name = "NPCSystem"
	add_child(npcs)
	gathering = GATHERING_SCENE.new()
	gathering.name = "GatheringSystem"
	add_child(gathering)
	combat = COMBAT_SCENE.new()
	combat.name = "CombatSystem"
	add_child(combat)
	crafting = CRAFTING_SCENE.new()
	crafting.name = "CraftingSystem"
	add_child(crafting)
	location_system = LOCATION_SCENE.new()
	location_system.name = "LocationSystem"
	add_child(location_system)
	freeplay = FREEPLAY_SCENE.new()
	freeplay.name = "FreeplaySystem"
	add_child(freeplay)
	await registry.ready
	interactions.configure(registry)
	location_system.configure(registry)

	world = WORLD_SCENE.new()
	world.name = "LarkmereValley"
	add_child(world)
	vfx_root = Node2D.new()
	vfx_root.name = "VFX"
	vfx_root.z_index = 40
	add_child(vfx_root)
	_spawn_gather_nodes()
	_spawn_npc_visuals()
	_add_world_fx()

	weather = WEATHER_SCENE.new()
	add_child(weather)
	audio = AUDIO_SCENE.new()
	add_child(audio)

	player = PLAYER_SCENE.new()
	player.name = "Wayfarer"
	player.position = world_spawn_points.hearthfall
	add_child(player)
	player.state = state

	equipment_fx = Sprite2D.new()
	equipment_fx.texture = equipment_texture
	equipment_fx.region_enabled = true
	equipment_fx.region_rect = Rect2(0,0,32,32)
	equipment_fx.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	equipment_fx.z_index = 23
	add_child(equipment_fx)

	ui = UI_SCENE.new()
	ui.name = "HUD"
	add_child(ui)
	ui.state = state
	ui.creation_finished.connect(_on_creation_finished)
	ui.start_requested.connect(_on_start_requested)
	ui.sound_requested.connect(_play_cue)
	ui.craft_requested.connect(_craft_lamp)
	ui.settings_changed.connect(_apply_settings)
	ui.set_settings(settings.values)

	player.set_physics_process(false)
	ui.set_save_available(save_system.has_save())
	weather.set_weather(state.weather)
	_apply_settings(settings.values)


func _spawn_npc_visuals() -> void:
	for id in registry.npcs.keys():
		var data: EverduneNPCData = registry.npcs[id]
		var visual := NPC_VISUAL_SCENE.new()
		visual.name = String(data.id).capitalize()
		visual.setup(data)
		visual.set_state(state)
		visual.z_index = 18
		world.add_child(visual)

func _spawn_gather_nodes() -> void:
	var definitions := [
		{"id":"wood_1","resource":"wood","index":0,"pos":Vector2(205,150),"skill":"woodcutting","xp":10},
		{"id":"wood_2","resource":"wood","index":0,"pos":Vector2(760,165),"skill":"woodcutting","xp":12},
		{"id":"wood_3","resource":"wood","index":0,"pos":Vector2(155,92),"skill":"woodcutting","xp":10},
		{"id":"stone_1","resource":"stone","index":8,"pos":Vector2(180,360),"skill":"mining","xp":12},
		{"id":"stone_2","resource":"stone","index":8,"pos":Vector2(820,330),"skill":"mining","xp":14},
		{"id":"berry_1","resource":"berries","index":2,"pos":Vector2(120,140),"skill":"foraging","xp":8},
		{"id":"berry_2","resource":"berries","index":2,"pos":Vector2(205,315),"skill":"foraging","xp":8},
		{"id":"mushroom_1","resource":"mushrooms","index":3,"pos":Vector2(275,330),"skill":"foraging","xp":10},
		{"id":"herb_1","resource":"herbs","index":4,"pos":Vector2(590,315),"skill":"foraging","xp":10}
	]
	for data in definitions:
		var node := GATHER_SCENE.new()
		node.name = String(data.id)
		node.setup(String(data.resource), props_texture, int(data.index), data.pos, String(data.skill), int(data.xp))
		node.harvested.connect(_on_gathered)
		world.add_child(node)

func _on_gathered(node: Node) -> void:
	gathering.handle(node, state)
	if state.collections.get("wood", 0) >= 5:
		state._unlock_achievement("collector_wood")
	_spawn_sparkles(node.global_position)
	_play_cue("gather")
	_show_toast("Gathered %s +%d  •  node will regrow." % [node.resource_id.capitalize(), node.amount])

func _process(delta: float) -> void:
	if equipment_fx and player:
		equipment_fx.position = player.position + Vector2(0,-10)
		var equipped_tool := String(state.equipment.get("tool","hands"))
		var tool_index: int = int({"axe":0,"pickaxe":1,"wayfarer_blade":2,"fishing_rod":3}.get(equipped_tool,-1))
		equipment_fx.visible = tool_index >= 0
		if tool_index >= 0:
			equipment_fx.region_rect = Rect2(int(tool_index)*32,0,32,32)
	echo_cooldown = maxf(0.0, echo_cooldown-delta)
	fish_cooldown = maxf(0.0, fish_cooldown-delta)
	if fish_phase != "idle":
		fish_timer = maxf(0.0, fish_timer - delta)
		if fish_phase == "waiting_bite" and fish_timer <= 0.0:
			fish_phase = "bite"
			fish_timer = 1.15
			_play_cue("fish_bite")
			_spawn_fishing_bite_fx()
		elif fish_phase == "bite" and fish_timer <= 0.0:
			fish_phase = "idle"
			fish_cooldown = 0.8
			_play_cue("fish_miss")
			_show_toast("The silverfin slipped away. Cast again when the water settles.")
	toast_time = maxf(0.0, toast_time-delta)
	_update_nearby()
	if world and world.has_method("sync_state"):
		world.sync_state(state)
	if weather:
		weather.follow_player(player)
		weather.set_time(state.hour)
	if audio and audio.has_method("set_mood"):
		var audio_mood := "night" if state.hour >= 20 or state.hour < 6 else "day"
		if get_tree().get_nodes_in_group("enemies").size() > 0:
			audio_mood = "gate"
		audio.set_mood(audio_mood)
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
		KEY_Q: ui.toggle_quest_visibility()

func _update_nearby() -> void:
	var result: Dictionary = interactions.nearest(player.position, get_tree().get_nodes_in_group("gather_nodes"))
	nearby_kind = String(result.kind)
	nearby_id = String(result.id)
	if fish_phase == "waiting_bite":
		prompt = "Wait for the bite…"
		return
	if fish_phase == "bite":
		prompt = "E  REEL NOW"
		return
	if nearby_kind.is_empty():
		prompt = "WASD / Arrows move  •  E interact  •  I inventory  •  Q story panel  •  K save"
		return
	match nearby_kind:
		"npc": prompt = "E  Talk"
		"echo": prompt = "E  Listen to the Echo"
		"fish": prompt = "E  Fish"
		"home": prompt = "E  Rest at home"
		"dungeon": prompt = "E  Enter the Sleeping Gate"
		"activity":
			var location: EverduneLocationData = registry.location(nearby_id)
			prompt = "E  " + (location.activity_hint if location != null and not location.activity_hint.is_empty() else "Do something useful")
		"gather": prompt = "E  Gather " + nearby_id

func _interact() -> void:
	match nearby_kind:
		"npc": _talk(nearby_id)
		"echo": _discover_echo(nearby_id)
		"fish": _fish()
		"home": _rest()
		"dungeon": _enter_dungeon()
		"activity": _perform_activity(nearby_id)
		"gather":
			for node in get_tree().get_nodes_in_group("gather_nodes"):
				if node.resource_id == nearby_id and node.global_position.distance_to(player.position) < 34.0:
					node.gather()
					break

func _perform_activity(id: String) -> void:
	var result: Dictionary = freeplay.perform(id, state)
	if bool(result.ok):
		_play_cue("craft" if id in ["cookfire","building","decorating"] else "gather")
		if world and world.has_method("sync_state"):
			world.sync_state(state)
		_show_toast(String(result.message))
	else:
		_show_toast(String(result.message))

func _talk(id: String) -> void:
	var result: Dictionary = npcs.talk(id, registry, state)
	if not String(result.text).is_empty():
		ui.show_dialogue(String(result.title), String(result.text))
	if result.has("met_flag"):
		state.set_flag(String(result.met_flag), true)

func _discover_echo(id: String) -> void:
	if echo_cooldown > 0.0:
		return
	echo_cooldown = 1.5
	var result: Dictionary = echoes.discover(id, registry, state)
	if not bool(result.ok):
		var data: EverduneEchoData = result.get("data")
		if data != null:
			if result.reason == "locked":
				ui.show_dialogue(data.title, "The memory is silent. Another memory must be awakened first.")
			else:
				ui.show_dialogue(data.title, data.repeat_text)
		return
	var data: EverduneEchoData = result.data
	_play_cue("echo")
	_spawn_echo_burst(data.position)
	if world and world.has_method("awaken_echo"):
		world.awaken_echo(data.id)
	if data.world_memory_id == "silverrun_kindness":
		state.fish_luck += 2
	ui.show_echo_reveal(data.title, data.discovery_text)
	ui.show_dialogue(data.title, data.discovery_text)
	_show_toast("%s discovered  •  Memory Shard +%d  •  XP +%d" % [data.title, data.item_amount, data.xp_reward])

func _craft_lamp() -> void:
	if crafting.craft_hearth_lamp(state):
		_play_cue("craft")
		if world and world.has_method("place_hearth_lamp"):
			world.place_hearth_lamp()
		ui.show_dialogue("Hearth Lamp", "The lamp hums softly. A fragment of the old Hearthsong now lives in your hands.")
	else:
		ui.show_dialogue("Hearth Lamp", "Requires 3 Wood, 2 Stone and 1 Memory Shard.")

func _fish() -> void:
	if fish_cooldown > 0.0:
		return
	if fish_phase == "waiting_bite":
		return
	if fish_phase == "bite":
		_resolve_fish_catch()
		return
	fish_phase = "waiting_bite"
	fish_timer = 0.75 + randf_range(0.35, 0.95)
	_play_cue("fish_cast")
	_spawn_fishing_cast_fx()
	_show_toast("Line cast. Watch the float…")
	
func _resolve_fish_catch() -> void:
	fish_phase = "idle"
	fish_cooldown = 1.1
	var silverfin_chance := clampf(0.18 + float(state.fish_luck) * 0.04, 0.18, 0.36)
	var roll := randf()
	var catch_id := "river_fish"
	var catch_label := "river fish"
	if roll <= silverfin_chance:
		catch_id = "silverfin"
		catch_label = "silverfin"
		state.fish_luck += 1
	else:
		state.fish_luck = maxi(0, state.fish_luck - 1)
	state.add_item(catch_id,1)
	state.add_skill_xp("fishing",12)
	state.record_activity("fishing")
	if int(state.collections.get("silverfin",0)) >= 3:
		state._unlock_achievement("angler")
	_play_cue("fish_catch")
	_spawn_fishing_fx()
	state.add_xp(10 if catch_id == "silverfin" else 5)
	_show_toast("You caught a %s." % catch_label)

func _rest() -> void:
	state.energy = state.max_energy
	state.hp = state.max_hp
	state.advance_time(8)
	state.home_returns += 1
	state.record_activity("resting")
	state.set_flag("returned_home", true)
	state.remember_npc("mara", "shared_home_return")
	state.weather = "Rain" if state.hour >= 18 and state.hour < 21 else "Clear"
	weather.set_weather(state.weather)
	_play_cue("home")
	_show_toast("You rest at home. The valley feels a little quieter.")

func _attack() -> void:
	var result: Dictionary = combat.attack(state, player, ui, audio, vfx_root)
	if not bool(result.ok):
		_show_toast(String(result.message))
	elif bool(result.completed):
		ui.show_dialogue("The Sleeping Gate", String(result.message))
		_show_toast("Sleeping Gate cleared  •  Gold +5")
	_spawn_hit_fx(player.position)

func _enter_dungeon() -> void:
	var result: Dictionary = combat.enter_dungeon(state, world, player, ENEMY_SCENE, ui, audio)
	ui.show_dialogue("The Sleeping Gate", String(result.message))
	if bool(result.ok):
		_show_toast("Optional combat trial unlocked.")

func _save_game() -> void:
	if save_system.save_game(state, player):
		_show_toast("Game saved.")
	else:
		_show_toast("Save failed.")

func _load_game() -> void:
	if save_system.load_game(state, player):
		player.refresh_customisation()
		weather.set_weather(state.weather)
		if world and world.has_method("sync_state"):
			world.sync_state(state)
		_show_toast("Game loaded.")
	else:
		_show_toast("No save found yet.")

func _on_start_requested(continue_game: bool) -> void:
	if session_started:
		return
	if continue_game:
		if not save_system.load_game(state, player):
			return
		player.refresh_customisation()
		weather.set_weather(state.weather)
	else:
		state.reset_new_game()
		player.position = world_spawn_points.hearthfall
		weather.set_weather(state.weather)
	session_started = true
	player.set_physics_process(true)
	ui.begin_session()
	_show_toast("Welcome to Larkmere Valley.")

func _on_creation_finished() -> void:
	if session_started:
		return
	player.refresh_customisation()
	player.set_physics_process(true)
	session_started = true
	ui.begin_session()
	_save_game()
	ui.set_save_available(true)
	_show_toast("Welcome, %s." % state.character.name)

func _play_cue(kind: String) -> void:
	if audio:
		audio.cue(kind)

func _show_toast(message: String) -> void:
	toast = message
	toast_time = 3.0

func _spawn_sparkles(pos: Vector2) -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	for i in range(6):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(0,-3),Vector2(2,0),Vector2(0,3),Vector2(-2,0)])
		p.color = Color("#ead49a")
		p.position = pos + Vector2(randf_range(-10,10),randf_range(-8,8))
		vfx_root.add_child(p)
		var tween := create_tween()
		tween.tween_property(p,"position:y",p.position.y-randf_range(10,24),0.45)
		tween.parallel().tween_property(p,"modulate:a",0.0,0.45)
		tween.tween_callback(p.queue_free)

func _spawn_echo_burst(pos: Vector2) -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	for i in range(10):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(0,-4),Vector2(2,0),Vector2(0,4),Vector2(-2,0)])
		p.color = Color("#d9c78c")
		p.position = pos
		vfx_root.add_child(p)
		var angle := TAU * float(i)/10.0
		var tween := create_tween()
		tween.tween_property(p,"position",pos+Vector2(cos(angle),sin(angle))*28.0,0.65)
		tween.parallel().tween_property(p,"modulate:a",0.0,0.65)
		tween.tween_callback(p.queue_free)

func _spawn_fishing_fx() -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	for i in range(5):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(-2,0),Vector2(0,-3),Vector2(2,0),Vector2(0,3)])
		p.color = Color("#9abdc5")
		p.position = Vector2(730,370)
		vfx_root.add_child(p)
		var tween := create_tween()
		tween.tween_property(p,"position",p.position+Vector2((i-2)*5,-8-i*2),0.4)
		tween.parallel().tween_property(p,"modulate:a",0.0,0.4)
		tween.tween_callback(p.queue_free)

func _spawn_fishing_cast_fx() -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	var ripple := Polygon2D.new()
	ripple.polygon = PackedVector2Array([Vector2(-9,0),Vector2(-5,-2),Vector2(0,-3),Vector2(5,-2),Vector2(9,0),Vector2(5,2),Vector2(0,3),Vector2(-5,2)])
	ripple.color = Color("#8fb8bd")
	ripple.position = Vector2(730,370)
	vfx_root.add_child(ripple)
	var tween := create_tween()
	tween.tween_property(ripple,"scale",Vector2(2.0,2.0),0.55)
	tween.parallel().tween_property(ripple,"modulate:a",0.0,0.55)
	tween.tween_callback(ripple.queue_free)

func _spawn_fishing_bite_fx() -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	for i in range(8):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(0,-3),Vector2(2,0),Vector2(0,3),Vector2(-2,0)])
		p.color = Color("#e8c77c")
		p.position = Vector2(730,370)
		vfx_root.add_child(p)
		var angle := TAU * float(i) / 8.0
		var tween := create_tween()
		tween.tween_property(p,"position",p.position + Vector2(cos(angle),sin(angle))*18.0,0.28)
		tween.parallel().tween_property(p,"modulate:a",0.0,0.28)
		tween.tween_callback(p.queue_free)

func _spawn_hit_fx(pos: Vector2) -> void:
	if settings and not bool(settings.get_value("particles",true)):
		return
	for i in range(4):
		var p := Polygon2D.new()
		p.polygon = PackedVector2Array([Vector2(-3,0),Vector2(0,-2),Vector2(3,0),Vector2(0,2)])
		p.color = Color("#ead49a")
		p.position = pos
		vfx_root.add_child(p)
		var tween := create_tween()
		tween.tween_property(p,"position",pos+Vector2((i-2)*8,-8),0.25)
		tween.parallel().tween_property(p,"modulate:a",0.0,0.25)
		tween.tween_callback(p.queue_free)

func _add_world_fx() -> void:
	var fire := Sprite2D.new()
	fire.texture = load("res://assets/environment_fx.svg") as Texture2D
	fire.region_enabled = true
	fire.region_rect = Rect2(32,0,32,32)
	fire.position = Vector2(335,275)
	fire.scale = Vector2(1.5,1.5)
	fire.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	world.add_child(fire)
	var foliage := Sprite2D.new()
	foliage.texture = load("res://assets/environment_fx.svg") as Texture2D
	foliage.region_enabled = true
	foliage.region_rect = Rect2(96,0,32,32)
	foliage.position = Vector2(570,100)
	foliage.scale = Vector2(1.5,1.5)
	foliage.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	world.add_child(foliage)

func _apply_settings(values: Dictionary) -> void:
	if settings:
		for key in values.keys():
			settings.set_value(String(key), values[key])
	if world and world.has_method("set_water_animation"):
		world.set_water_animation(bool(values.get("animated_water",true)))
	if weather:
		weather.apply_settings(values)
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if bool(values.get("fullscreen",false)) else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if bool(values.get("vsync",true)) else DisplayServer.VSYNC_DISABLED)
	if get_window():
		get_window().content_scale_factor = float(values.get("ui_scale",1.0))
