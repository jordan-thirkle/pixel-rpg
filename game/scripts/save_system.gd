extends Node
class_name EverduneSaveSystem

const SAVE_PATH:="user://everdune_save.json"
const CURRENT_VERSION := 2

func has_save()->bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(state:Node,player:Node)->void:
	var payload={"version":CURRENT_VERSION,"state":state.snapshot(),"player":{"x":player.position.x,"y":player.position.y}}
	var file:=FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(payload))
		file.close()

func load_game(state:Node,player:Node)->bool:
	if not has_save(): return false
	var file:=FileAccess.open(SAVE_PATH,FileAccess.READ)
	if file==null:return false
	var parsed=JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed)!=TYPE_DICTIONARY:return false
	var version := int(parsed.get("version", 0))
	if version <= 0 or version > CURRENT_VERSION:
		return false
	if parsed.has("state"):state.restore(_migrate_state(parsed.state, version))
	if parsed.has("player"):player.position=Vector2(float(parsed.player.x),float(parsed.player.y))
	return true

func _migrate_state(data: Dictionary, version: int) -> Dictionary:
	var migrated := data.duplicate(true)
	if version < 2:
		if not migrated.has("collections"):
			migrated["collections"] = {"silverfin":0,"memory_shard":0,"wood":0,"stone":0}
		if not migrated.has("achievements"):
			migrated["achievements"] = {}
	return migrated
