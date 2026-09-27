extends SceneTree

const STATE := preload("res://scripts/game_state.gd")
const SAVE := preload("res://scripts/save_system.gd")
const REGISTRY := preload("res://scripts/content_registry.gd")
const ECHO := preload("res://scripts/systems/echo_system.gd")

func _initialize() -> void:
	var state := STATE.new()
	assert state.has_item("wood", 3)
	var registry := REGISTRY.new()
	root.add_child(registry)
	await process_frame
	assert registry.echo("old_road") != null
	assert registry.npc("mara") != null
	var echo_system := ECHO.new()
	var result := echo_system.discover("old_road", registry, state)
	assert bool(result.ok)
	assert state.flags.old_road_echo
	assert state.echoes == 1
	assert int(state.inventory.memory_shard) == 1
	var locked := echo_system.discover("glass_orchard", registry, state)
	assert not bool(locked.ok)
	state.set_flag("mara_echo_return", true)
	var save := SAVE.new()
	assert save_system_shape(save)
	print("Everdune vertical slice data/regression checks passed.")
	quit()

func save_system_shape(save: Node) -> bool:
	assert save.CURRENT_VERSION >= 2
	return true
