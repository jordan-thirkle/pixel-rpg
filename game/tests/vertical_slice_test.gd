extends SceneTree

const STATE := preload("res://scripts/game_state.gd")
const SAVE := preload("res://scripts/save_system.gd")
const REGISTRY := preload("res://scripts/content_registry.gd")
const ECHO := preload("res://scripts/systems/echo_system.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	assert(state.has_item("wood",3))
	var registry := REGISTRY.new()
	registry._ready()
	assert(registry.echo("old_road") != null)
	assert(registry.npc("mara") != null)
	assert(registry.location("home") != null)
	var echo_system := ECHO.new()
	var result: Dictionary = echo_system.discover("old_road",registry,state)
	assert(bool(result.get("ok",false)))
	assert(bool(state.flags.get("old_road_echo",false)))
	assert(state.echoes == 1)
	assert(int(state.inventory.get("memory_shard",0)) == 1)
	var locked: Dictionary = echo_system.discover("glass_orchard",registry,state)
	assert(not bool(locked.get("ok",false)))
	var save := SAVE.new()
	assert(int(save.CURRENT_VERSION) >= 3)
	print("Everdune vertical slice data/regression checks passed.")
	quit()
