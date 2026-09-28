extends Node
class_name EverduneSaveSystem

const SAVE_PATH := "user://everdune_save.json"
const TEMP_PATH := "user://everdune_save.tmp.json"
const CURRENT_VERSION := 4

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(state: Node, player: Node) -> bool:
	var payload := {"version":CURRENT_VERSION,"state":state.snapshot(),"player":{"x":player.position.x,"y":player.position.y}}
	var file := FileAccess.open(TEMP_PATH,FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(payload))
	file.close()
	if not FileAccess.file_exists(TEMP_PATH):
		return false
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	return DirAccess.rename_absolute(TEMP_PATH,SAVE_PATH) == OK

func load_game(state: Node, player: Node) -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH,FileAccess.READ)
	if file == null:
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var version := int(parsed.get("version",0))
	if version <= 0 or version > CURRENT_VERSION:
		return false
	if parsed.has("state"):
		state.restore(_migrate_state(parsed.state,version))
	if parsed.has("player"):
		var player_data: Dictionary = parsed.player
		player.position = Vector2(float(player_data.get("x",480.0)),float(player_data.get("y",290.0)))
	return true

func migrate_state_for_test(data: Dictionary, version: int) -> Dictionary:
	return _migrate_state(data,version)

func _migrate_state(data: Dictionary, version: int) -> Dictionary:
	var migrated := data.duplicate(true)
	if version < 2:
		if not migrated.has("collections"):
			migrated["collections"] = {"silverfin":0,"memory_shard":0,"wood":0,"stone":0}
		if not migrated.has("achievements"):
			migrated["achievements"] = {}
	if version < 3:
		if not migrated.has("max_hp"):
			migrated["max_hp"] = 100
		if not migrated.has("max_energy"):
			migrated["max_energy"] = 100
		if not migrated.has("equipment"):
			migrated["equipment"] = {"tool":"axe","weapon":"wayfarer_blade","armor":"traveller_coat"}
	if not migrated.has("fish_luck"): migrated["fish_luck"] = 0
	if not migrated.has("home_returns"): migrated["home_returns"] = 0
	if not migrated.has("relationship_mara"): migrated["relationship_mara"] = 0
	if not migrated.has("combat_streak"): migrated["combat_streak"] = 0
	if not migrated.has("activity_counts"): migrated["activity_counts"] = {}
	if not migrated.has("world_memory"): migrated["world_memory"] = {}
	if not migrated.has("npc_memories"): migrated["npc_memories"] = {}
	if not migrated.has("home_level"): migrated["home_level"] = 1
	if not migrated.has("home_display_items"): migrated["home_display_items"] = []
	if not migrated.has("garden_planted_day"): migrated["garden_planted_day"] = 0
	if not migrated.has("garden_ready"): migrated["garden_ready"] = false
	return migrated
