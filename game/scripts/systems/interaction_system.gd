extends Node
class_name EverduneInteractionSystem

var locations: Array[Dictionary] = []

func configure(registry: Node) -> void:
	locations.clear()
	for id in registry.npcs.keys():
		var npc: EverduneNPCData = registry.npcs[id]
		locations.append({"id": npc.id, "kind": "npc", "pos": npc.position, "radius": 34.0})
	for id in registry.echoes.keys():
		var echo: EverduneEchoData = registry.echoes[id]
		locations.append({"id": echo.id, "kind": "echo", "pos": echo.position, "radius": 42.0})
	locations.append({"id": "fishing", "kind": "fish", "pos": Vector2(730,370), "radius": 58.0})
	locations.append({"id": "home", "kind": "home", "pos": Vector2(430,235), "radius": 48.0})
	locations.append({"id": "dungeon", "kind": "dungeon", "pos": Vector2(820,430), "radius": 50.0})

func nearest(player_position: Vector2, gather_nodes: Array[Node]) -> Dictionary:
	var result := {"kind": "", "id": "", "distance": 99999.0}
	for item in locations:
		var distance: float = player_position.distance_to(item.pos)
		if distance < float(item.radius) and distance < result.distance:
			result = {"kind": item.kind, "id": item.id, "distance": distance}
	for node in gather_nodes:
		if node.can_gather():
			var distance: float = player_position.distance_to(node.global_position)
			if distance < 34.0 and distance < result.distance:
				result = {"kind": "gather", "id": node.resource_id, "distance": distance}
	return result
