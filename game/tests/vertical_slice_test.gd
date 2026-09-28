extends SceneTree

const STATE := preload("res://scripts/game_state.gd")
const SAVE := preload("res://scripts/save_system.gd")
const REGISTRY := preload("res://scripts/content_registry.gd")
const ECHO := preload("res://scripts/systems/echo_system.gd")
const WORLD := preload("res://scripts/world_tiles.gd")
const PLAYER := preload("res://scripts/player.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var fresh := STATE.new()
	fresh.reset_new_game()
	assert(String(fresh.character.name).is_empty())
	assert(not bool(fresh.flags.get("old_road_echo", false)))
	assert(fresh.echoes == 0)
	assert(fresh.relationship_mara == 0)
	assert(fresh.home_returns == 0)
	assert(fresh.combat_streak == 0)

	var registry := REGISTRY.new()
	registry._ready()
	assert(registry.echo("old_road") != null)
	assert(registry.echo("glass_orchard") != null)
	assert(registry.echo("bellroot_memory") != null)
	assert(registry.echo("silverrun_memory") != null)
	assert(registry.location("cookfire") != null)
	assert(registry.location("garden") != null)
	assert(registry.location("wayfinding") != null)
	assert(registry.location("workbench") != null)
	assert(registry.location("decorating") != null)
	assert(registry.npc("mara") != null)
	assert(registry.location("home") != null)
	assert(registry.location("dungeon") != null)

	var world := WORLD.new()
	root.add_child(world)
	await process_frame
	assert(world.layer != null)
	assert(world.water_layer != null)
	assert(world.path_layer != null)
	assert(world.water_layer.get_cell_source_id(Vector2i(19, 1)) == 0)
	assert(world.path_layer.get_cell_source_id(Vector2i(18, 8)) == 0)
	assert(world.path_layer.get_cell_source_id(Vector2i(25, 8)) == 0)
	assert(world.water_layer.get_cell_source_id(Vector2i(19, 8)) == -1)
	var tile_set: TileSet = world.water_layer.tile_set
	assert(tile_set.get_physics_layers_count() == 1)
	var water_source := tile_set.get_source(0) as TileSetAtlasSource
	var water_data := water_source.get_tile_data(Vector2i(1, 0), 0)
	assert(water_data.get_collision_polygons_count(0) == 1)
	world.queue_free()

	var echo_system := ECHO.new()
	var result: Dictionary = echo_system.discover("old_road",registry,fresh)
	assert(bool(result.get("ok",false)))
	assert(bool(fresh.flags.get("old_road_echo",false)))
	assert(fresh.echoes == 1)
	assert(int(fresh.inventory.get("memory_shard",0)) == 1)
	assert(fresh.world_memory.has("old_road_mapped") == false)
	var orchard_result: Dictionary = echo_system.discover("glass_orchard",registry,fresh)
	assert(bool(orchard_result.get("ok",false)))
	assert(bool(fresh.flags.get("glass_orchard_echo",false)))

	var freeplay := preload("res://scripts/systems/freeplay_system.gd").new()
	fresh.inventory["seeds"] = 1
	var garden_result: Dictionary = freeplay.perform("garden", fresh)
	assert(bool(garden_result.ok))
	fresh.day += 1
	fresh.garden_ready = true
	var harvest_result: Dictionary = freeplay.perform("garden", fresh)
	assert(bool(harvest_result.ok))
	assert(int(fresh.skills.get("farming",1)) >= 1)
	fresh.inventory["wood"] = 8
	fresh.inventory["stone"] = 5
	var build_result: Dictionary = freeplay.perform("building", fresh)
	assert(bool(build_result.ok))
	assert(fresh.home_level == 2)
	var save := SAVE.new()
	assert(int(save.CURRENT_VERSION) >= 4)

	# Production hero layers: all nine layers must be real 4x4 crisp-edge sheets.
	var hero_assets := [
		"res://assets/player_body.svg","res://assets/player_hair.svg","res://assets/player_coat.svg",
		"res://assets/hero_face.svg","res://assets/hero_shirt.svg","res://assets/hero_trousers.svg",
		"res://assets/hero_boots.svg","res://assets/hero_accessory.svg","res://assets/hero_back.svg"
	]
	for asset in hero_assets:
		assert(ResourceLoader.exists(asset))
		var file := FileAccess.open(asset, FileAccess.READ)
		assert(file != null)
		var svg := file.get_as_text()
		assert(svg.contains('width="128"'))
		assert(svg.contains('height="128"'))
		assert(svg.count('<g transform="translate(') == 16)
		assert(svg.contains('shape-rendering="crispEdges"'))

	# Final score contract: every gameplay event has a named authored motif.
	var audio := FileAccess.open("res://scripts/audio.gd", FileAccess.READ)
	assert(audio != null)
	var audio_source := audio.get_as_text()
	for cue in ["gather","fish_cast","fish_bite","fish_catch","fish_miss","echo","craft","ui","level","swing","hit","defeat","gate_open","home"]:
		assert(audio_source.contains('"'+cue+'":'))
	assert(audio_source.contains("func _ambient_chord"))
	assert(audio_source.contains('mood := "day"'))

	assert(ResourceLoader.exists("res://assets/sleeping_gate.svg"))
	print("Everdune Hearthfall production visual/audio regression checks passed.")
	quit()
