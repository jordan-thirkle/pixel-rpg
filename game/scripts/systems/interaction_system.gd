extends Node
class_name EverduneInteractionSystem

var locations: Array[Dictionary] = []

func configure(registry: Node) -> void:
	locations.clear()
	for id in registry.echoes.keys():
		var echo: EverduneEchoData = registry.echoes[id]
		locations.append({"id": echo.id, "kind": "echo", "pos": echo.position, "radius": 42.0})
	for id in registry.locations.keys():
		var location: EverduneLocationData = registry.locations[id]
		if location.kind != "region":
			locations.append({"id": location.id, "kind": location.kind, "pos": location.position, "radius": location.interaction_radius, "prerequisite_flags": location.prerequisite_flags})

func nearest(player_position: Vector2, gather_nodes: Array[Node]) -> Dictionary:
	var result := {"kind": "", "id": "", "distance": 99999.0}
	for npc in get_tree().get_nodes_in_group("npc_visuals"):
		var distance: float = player_position.distance_to(npc.global_position)
		if distance < 38.0 and distance < result.distance:
			result = {"kind": "npc", "id": String(npc.npc_data.id), "distance": distance}
	for item in locations:
		var distance: float = player_position.distance_to(item.pos)
		if distance < float(item.radius) and distance < result.distance:
			var allowed := true
			for flag in item.get("prerequisite_flags",[]):
				if not bool(get_parent().state.flags.get(flag,false)):
					allowed = false
					break
			if allowed:
				result = {"kind": item.kind, "id": item.id, "distance": distance}
	for node in gather_nodes:
		if node.can_gather():
			var distance: float = player_position.distance_to(node.global_position)
			if distance < 34.0 and distance < result.distance:
				result = {"kind": "gather", "id": node.resource_id, "distance": distance}
	return result
