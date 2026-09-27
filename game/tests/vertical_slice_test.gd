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
	# Clean-save first-run contract.
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
	assert(registry.npc("mara") != null)
	assert(registry.location("home") != null)
	assert(registry.location("dungeon") != null)

	# TileMap topology + collision must exist in the actual runtime world.
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

	# Signature Echo contract.
	var echo_system := ECHO.new()
	var result: Dictionary = echo_system.discover("old_road",registry,fresh)
	assert(bool(result.get("ok",false)))
	assert(bool(fresh.flags.get("old_road_echo",false)))
	assert(fresh.echoes == 1)
	assert(int(fresh.inventory.get("memory_shard",0)) == 1)
	# The Orchard becomes available only after the first memory.
	var orchard_result: Dictionary = echo_system.discover("glass_orchard",registry,fresh)
	assert(bool(orchard_result.get("ok",false)))
	assert(bool(fresh.flags.get("glass_orchard_echo",false)))

	# Save schema remains versioned.
	var save := SAVE.new()
	assert(int(save.CURRENT_VERSION) >= 3)

	# Production hero layers are part of the runtime contract.
	for asset in [
		"res://assets/hero_face.svg","res://assets/hero_shirt.svg",
		"res://assets/hero_trousers.svg","res://assets/hero_boots.svg",
		"res://assets/hero_accessory.svg","res://assets/hero_back.svg",
		"res://assets/sleeping_gate.svg"
	]:
		assert(ResourceLoader.exists(asset))

	print("Everdune Hearthfall Vertical Slice 1.0 regression checks passed.")
	quit()
