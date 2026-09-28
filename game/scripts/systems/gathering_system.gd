extends Node
class_name EverduneGatheringSystem

signal gathered(node: Node, resource_id: String, amount: int)

func handle(node: Node, state: Node) -> void:
	state.add_item(node.resource_id, node.amount)
	var skill := String(node.get("skill_id")) if node.get("skill_id") != null else "gathering"
	var xp := int(node.get("skill_xp")) if node.get("skill_xp") != null else 10
	state.add_skill_xp(skill, xp)
	state.add_xp(maxi(2, int(xp / 3)))
	state.record_activity(skill)
	if skill == "foraging" and int(state.activity_counts.get("foraging",0)) == 1:
		state.set_flag("foraged_first_plant", true)
	gathered.emit(node, node.resource_id, node.amount)
