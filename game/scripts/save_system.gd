extends Node
class_name EverduneSaveSystem

const SAVE_PATH:="user://everdune_save.json"

func has_save()->bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(state:Node,player:Node)->void:
	var payload={"version":1,"state":state.snapshot(),"player":{"x":player.position.x,"y":player.position.y}}
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
	if parsed.has("state"):state.restore(parsed.state)
	if parsed.has("player"):player.position=Vector2(float(parsed.player.x),float(parsed.player.y))
	return true
