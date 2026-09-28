extends Node
class_name EverduneNPCSystem

func talk(id: String, registry: Node, state: Node) -> Dictionary:
	var data: EverduneNPCData = registry.npc(id)
	if data == null:
		return {"title": id, "text": ""}

	var relationship := state.relationship(id)
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

	var talk_memory := "talked_day_" + str(state.day)
	var memories: Array = state.npc_memories.get(id, [])
	if talk_memory not in memories:
		state.adjust_relationship(id, 1)
		state.remember_npc(id, talk_memory)
		if state.relationship(id) == 1:
			state.set_flag(id + "_bond_started", true)
	if id == "mara" and state.relationship(id) >= 3:
		state.set_flag("mara_bond_established", true)
	return {"title": data.display_name, "text": text, "met_flag": data.met_flag}


func _memory_dialogue(id: String, state: Node) -> String:
	var data: EverduneNPCData = get_parent().registry.npc(id)
	if data != null and not data.goal_flag.is_empty() and bool(state.flags.get(data.goal_flag, false)) and not data.goal_dialogue.is_empty():
		return data.goal_dialogue
	if data != null and not data.weather_dialogue.is_empty() and state.weather != "Clear":
		return data.weather_dialogue
	if id == "mara":
		if bool(state.flags.get("garden_harvested", false)) and state.relationship_mara >= 2:
			return "The garden looks good. Funny how a place starts feeling like home once something you planted is growing there."
		if int(state.activity_counts.get("fishing",0)) >= 5:
			return "You have been spending time on the river. Silverrun suits people who can sit still long enough to notice it changing."
		if bool(state.flags.get("home_workshop", false)):
			return "I saw the new workbench. You're not just passing through anymore, are you?"
	if id == "rowan":
		if int(state.activity_counts.get("wayfinding",0)) >= 3:
			return "You've started reading the land instead of just crossing it. Keep your map close."
		if int(state.activity_counts.get("archaeology",0)) >= 1:
			return "That old token matters. Bellroot was a community before it was an excavation."
		if bool(state.flags.get("mapped_old_road", false)):
			return "The old road is on your map now. Good. A remembered path is more useful when someone can walk it again."
		if bool(state.flags.get("knowledge_bellroot", false)):
			return "Three taps before the mine. The old miners had their rituals for a reason."
	return ""
