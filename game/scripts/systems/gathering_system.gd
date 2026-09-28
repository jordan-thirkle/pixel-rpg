extends Node
class_name EverduneGatheringSystem

signal gathered(node: Node, resource_id: String, amount: int)

func handle(node: Node, state: Node) -> void:
	var skill := String(node.get("skill_id")) if node.get("skill_id") != null else "gathering"
	var xp := int(node.get("skill_xp")) if node.get("skill_xp") != null else 10
	var skill_level := int(state.skills.get(skill, 1))
	var amount := int(node.amount)
	if skill_level >= 4 and randf() < 0.24:
		amount += 1
	state.add_item(node.resource_id, amount)
	state.add_skill_xp(skill, xp + skill_level)
	state.add_skill_xp("gathering", maxi(2, int(xp / 3)))
	state.add_xp(maxi(2, int(xp / 3)) + (2 if amount > int(node.amount) else 0))
	state.record_activity(skill)

	var bonus_id := String(node.get("bonus_resource_id"))
	var bonus_chance := float(node.get("bonus_chance"))
	if not bonus_id.is_empty() and skill_level >= 3 and randf() < bonus_chance:
		state.add_item(bonus_id, 1)
		state.record_world_memory("foraging_rich_" + skill, "%s knowledge is becoming richer." % skill.capitalize())

	if skill == "foraging" and int(state.activity_counts.get("foraging",0)) == 1:
		state.set_flag("foraged_first_plant", true)
	gathered.emit(node, node.resource_id, amount)
