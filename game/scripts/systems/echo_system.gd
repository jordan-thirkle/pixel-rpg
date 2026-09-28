extends Node
class_name EverduneEchoSystem

signal discovered(data: EverduneEchoData)

func discover(id: String, registry: Node, state: Node) -> Dictionary:
	var data: EverduneEchoData = registry.echo(id)
	if data == null:
		return {"ok": false, "reason": "missing"}
	for flag in data.prerequisite_flags:
		if not bool(state.flags.get(flag, false)):
			return {"ok": false, "reason": "locked", "data": data}
	for activity_id in data.prerequisite_activities.keys():
		if state.activity_count(String(activity_id)) < int(data.prerequisite_activities[activity_id]):
			return {"ok": false, "reason": "experience", "data": data}
	if bool(state.flags.get(data.completion_flag, false)):
		return {"ok": false, "reason": "repeat", "data": data}
	state.set_flag(data.completion_flag, true)
	state.quest_stage = maxi(state.quest_stage, data.quest_stage)
	state.add_skill_xp("memory", data.memory_xp)
	state.echoes += 1
	state.add_xp(data.xp_reward)
	if not data.world_memory_id.is_empty():
		state.record_world_memory(data.world_memory_id, data.consequence_text)
	if not data.knowledge_tag.is_empty():
		state.set_flag("knowledge_" + data.knowledge_tag, true)
	for unlock_flag in data.unlock_flags:
		state.set_flag(unlock_flag, true)
	if data.relationship_bonus > 0 and not data.relationship_npc_id.is_empty():
		state.adjust_relationship(data.relationship_npc_id, data.relationship_bonus)
	state.record_activity("echo_" + data.memory_kind)
	if not data.item_id.is_empty():
		state.add_item(data.item_id, data.item_amount)
	discovered.emit(data)
	return {"ok": true, "data": data}
