extends Node
class_name EverduneContentRegistry

var echoes: Dictionary = {}
var npcs: Dictionary = {}
var locations: Dictionary = {}

func _ready() -> void:
	_load_echo("res://data/echoes/old_road.tres")
	_load_echo("res://data/echoes/glass_orchard.tres")
	_load_npc("res://data/npcs/mara.tres")
	_load_npc("res://data/npcs/rowan.tres")
	_load_location("res://data/locations/larkmere.tres")
	_load_location("res://data/locations/fishing.tres")
	_load_location("res://data/locations/home.tres")
	_load_location("res://data/locations/sleeping_gate.tres")

func _load_echo(path: String) -> void:
	var data := load(path) as EverduneEchoData
	if data != null:
		echoes[data.id] = data

func _load_npc(path: String) -> void:
	var data := load(path) as EverduneNPCData
	if data != null:
		npcs[data.id] = data

func _load_location(path: String) -> void:
	var data := load(path) as EverduneLocationData
	if data != null:
		locations[data.id] = data

func echo(id: String) -> EverduneEchoData:
	return echoes.get(id)

func npc(id: String) -> EverduneNPCData:
	return npcs.get(id)

func location(id: String) -> EverduneLocationData:
	return locations.get(id)
