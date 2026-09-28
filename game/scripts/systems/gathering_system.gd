extends Node
class_name EverduneGatheringSystem

signal gathered(node: Node, resource_id: String, amount: int)

func handle(node: Node, state: Node) -> void:
	var skill := String(node.get("skill_id")) if node.get("skill_id") != null else "gathering"
	var base_amount := maxi(1, int(node.get("amount")) if node.get("amount") != null else 1)
	var skill_level := int(state.skills.get(skill, 1))
	var activity_count := int(state.activity_counts.get(skill, 0)) + 1
	var amount := base_amount

	# Gathering mastery is deliberately compact: better hands produce more from the
	# same authored node rather than introducing a second progression system.
	if skill_level >= 4 and activity_count % 3 == 0:
		amount += 1
	elif skill_level >= 2 and activity_count % 5 == 0:
		amount += 1

	state.add_item(String(node.resource_id), amount)
	var xp := int(node.get("skill_xp")) if node.get("skill_xp") != null else 10
	state.add_skill_xp(skill, xp + (2 if skill_level >= 3 else 0))
	state.add_xp(maxi(2, int(xp / 3)))
	state.record_activity(skill)

	# The first meaningful use of each gathering discipline becomes remembered
	# world knowledge. This gives gathering a consequence beyond inventory numbers.
	if int(state.activity_counts.get(skill, 0)) == 1:
		state.set_flag("gathered_" + skill + "_first", true)
		state.record_world_memory("first_" + skill, String(node.resource_id))

	# Experienced gatherers occasionally uncover a memory shard. The cadence is
	# deterministic so progression is reliable rather than a frustrating RNG grind.
	var refreshed_count := int(state.activity_counts.get(skill, 0))
	if skill_level >= 3 and refreshed_count % 6 == 0:
		state.add_item("memory_shard", 1)
		state.record_world_memory("gathering_memory_" + skill, String(node.resource_id))
		state.set_flag("found_gathering_memory", true)
		if node.has_method("show_mastery_feedback"):
			node.show_mastery_feedback("A buried memory answers your hands.")
		gathered.emit(node, String(node.resource_id), amount)
		return

	if node.has_method("show_mastery_feedback"):
		if skill_level >= 4 and amount > base_amount:
			node.show_mastery_feedback("Mastery yields more from the same find.")
		elif skill_level >= 2 and amount > base_amount:
			node.show_mastery_feedback("Your practiced hands find a little more.")

	if skill == "foraging" and int(state.activity_counts.get("foraging",0)) == 1:
		state.set_flag("foraged_first_plant", true)
	gathered.emit(node, String(node.resource_id), amount)
