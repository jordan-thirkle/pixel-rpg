extends Node
class_name EverduneNPCSystem

func talk(id: String, registry: Node, state: Node) -> Dictionary:
	var data: EverduneNPCData = registry.npc(id)
	if data == null:
		return {"title": id, "text": ""}
	var text := data.default_dialogue
	if not data.evening_dialogue.is_empty() and state.hour >= data.evening_hour:
		text = data.evening_dialogue
	elif not data.post_echo_flag.is_empty() and bool(state.flags.get(data.post_echo_flag, false)) and not bool(state.flags.get("mara_echo_return", false)) and not data.post_echo_dialogue.is_empty():
		text = data.post_echo_dialogue
		if id == "mara":
			state.set_flag("mara_echo_return", true)
			state.add_xp(30)
	return {"title": data.display_name, "text": text, "met_flag": data.met_flag}
