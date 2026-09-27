extends Node
class_name EverduneGatheringSystem

signal gathered(node: Node, resource_id: String, amount: int)

func handle(node: Node, state: Node) -> void:
	state.add_item(node.resource_id, node.amount)
	state.add_skill_xp("gathering", 10)
	state.add_xp(4)
	gathered.emit(node, node.resource_id, node.amount)
