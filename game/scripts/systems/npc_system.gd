extends Node
class_name EverduneNPCSystem

func talk(id: String, registry: Node, state: Node) -> Dictionary:
	var data: EverduneNPCData = registry.npc(id)
	if data == null:
		return {"title": id, "text": ""}

	var relationship := int(state.relationship_mara) if id == "mara" else 0
	var text := data.default_dialogue
	var memory_text := _memory_dialogue(id, state)
	if relationship >= 3 and not data.relationship_dialogue.is_empty():
		text = data.relationship_dialogue
	elif not data.post_echo_flag.is_empty() and bool(state.flags.get(data.post_echo_flag, false)) and not bool(state.flags.get("mara_echo_return", false)) and not data.post_echo_dialogue.is_empty():
		text = data.post_echo_dialogue
		if id == "mara":
			state.set_flag("mara_echo_return", true)
			state.add_xp(30)
			state.set_flag("mara_understands", true)
	elif not memory_text.is_empty():
		text = memory_text
	elif not data.evening_dialogue.is_empty() and state.hour >= data.evening_hour:
		text = data.evening_dialogue

	if id == "mara":
		state.relationship_mara = mini(10, int(state.relationship_mara) + 1
		)
		state.remember_npc(id, "talked_day_" + str(state.day))
		if state.relationship_mara == 1:
			state.set_flag("mara_bond_started", true)
	return {"title": data.display_name, "text": text, "met_flag": data.met_flag}


func _memory_dialogue(id: String, state: Node) -> String:
	if id == "mara":
		if bool(state.flags.get("garden_harvested", false)) and state.relationship_mara >= 2:
			return "The garden looks good. Funny how a place starts feeling like home once something you planted is growing there."
		if int(state.activity_counts.get("fishing",0)) >= 5:
			return "You have been spending time on the river. Silverrun suits people who can sit still long enough to notice it changing."
		if bool(state.flags.get("home_workshop", false)):
			return "I saw the new workbench. You're not just passing through anymore, are you?"
	if id == "rowan":
		if bool(state.flags.get("mapped_old_road", false)):
			return "The old road is on your map now. Good. A remembered path is more useful when someone can walk it again."
		if bool(state.flags.get("knowledge_bellroot", false)):
			return "Three taps before the mine. The old miners had their rituals for a reason."
	return ""
