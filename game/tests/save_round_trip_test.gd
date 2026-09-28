extends SceneTree

const STATE := preload("res://scripts/game_state.gd")
const SAVE := preload("res://scripts/save_system.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var save := SAVE.new()
	var state := STATE.new()
	var player := Node2D.new()
	state.character["name"] = "Round Trip"
	state.set_flag("old_road_echo",true)
	state.add_item("memory_shard",2)
	state.quest_stage = 5
	state.relationship_mara = 4
	state.home_returns = 2
	state.combat_streak = 1
	state.home_level = 2
	state.garden_planted_day = 3
	state.garden_ready = true
	state.record_activity("fishing")
	state.record_world_memory("old_road_mapped","shortcut")
	state.remember_npc("mara","shared_home_return")
	state.add_home_display("silverfin_trophy")
	player.position = Vector2(612,344)
	assert(save.save_game(state,player))
	var restored := STATE.new()
	var restored_player := Node2D.new()
	assert(save.load_game(restored,restored_player))
	assert(restored.character.name == "Round Trip")
	assert(restored.flags.old_road_echo)
	assert(restored.quest_stage == 5)
	assert(int(restored.inventory.memory_shard) == 2)
	assert(restored.relationship_mara == 4)
	assert(restored.home_returns == 2)
	assert(restored.combat_streak == 1)
	assert(restored.home_level == 2)
	assert(restored.garden_ready)
	assert(int(restored.activity_counts.get("fishing",0)) == 1)
	assert(restored.world_memory.has("old_road_mapped"))
	assert(restored.npc_memories.has("mara"))
	assert(restored.home_display_items.has("silverfin_trophy"))
	assert(restored_player.position == Vector2(612,344))
	if FileAccess.file_exists(save.SAVE_PATH):
		DirAccess.remove_absolute(save.SAVE_PATH)
	if FileAccess.file_exists(save.TEMP_PATH):
		DirAccess.remove_absolute(save.TEMP_PATH)
	print("Everdune save round-trip checks passed.")
	quit()
