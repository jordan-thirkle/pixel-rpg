extends Node
class_name EverduneLocationSystem

var locations: Dictionary = {}

func configure(registry: Node) -> void:
	locations = registry.locations.duplicate(true)

func has(id: String) -> bool:
	return locations.has(id)

func get_location(id: String) -> EverduneLocationData:
	return locations.get(id)
