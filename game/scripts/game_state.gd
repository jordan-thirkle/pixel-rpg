extends Node
class_name EverduneGameState

signal changed

var day := 1
var hour := 8
var minute := 15
var season := "Spring"
var year := 1
var hp := 100
var max_hp := 100
var energy := 100
var max_energy := 100
var level := 1
var xp := 0
var gold := 25
var echoes := 0
var inventory := {"wood": 3, "stone": 2, "river_fish": 0, "memory_shard": 0, "hearthstone": 0}
var flags := {}
var crafted := {}
var weather := "Clear"
var character := {"name":"","hair":"dark","coat":"teal"}

func add_item(id: String, amount: int) -> void:
	inventory[id] = int(inventory.get(id, 0)) + amount
	changed.emit()

func remove_item(id: String, amount: int) -> bool:
	var current := int(inventory.get(id, 0))
	if current < amount:
		return false
	inventory[id] = current - amount
	changed.emit()
	return true

func has_item(id: String, amount: int = 1) -> bool:
	return int(inventory.get(id, 0)) >= amount

func add_xp(amount: int) -> void:
	xp += amount
	var threshold := 50 + (level - 1) * 35
	while xp >= threshold:
		xp -= threshold
		level += 1
		max_hp += 5
		max_energy += 5
		hp = max_hp
		energy = max_energy
		threshold = 50 + (level - 1) * 35
	changed.emit()

func set_flag(id: String, value: bool) -> void:
	flags[id] = value
	changed.emit()

func advance_time(hours: int) -> void:
	hour += hours
	while hour >= 24:
		hour -= 24
		day += 1
	changed.emit()

func craft_hearth_lamp() -> bool:
	if not has_item("wood", 3) or not has_item("stone", 2) or not has_item("memory_shard", 1):
		return false
	remove_item("wood", 3)
	remove_item("stone", 2)
	remove_item("memory_shard", 1)
	inventory["hearthstone"] += 1
	crafted["hearth_lamp"] = int(crafted.get("hearth_lamp", 0)) + 1
	add_xp(20)
	changed.emit()
	return true

func snapshot() -> Dictionary:
	return {"day":day,"hour":hour,"minute":minute,"season":season,"year":year,"hp":hp,"energy":energy,"level":level,"xp":xp,"gold":gold,"echoes":echoes,"inventory":inventory,"flags":flags,"crafted":crafted,"weather":weather,"character":character}

func restore(data: Dictionary) -> void:
	for key in ["day","hour","minute","season","year","hp","energy","level","xp","gold","echoes"]:
		if data.has(key):
			set(key, data[key])
	if data.has("inventory"):
		inventory = data.inventory.duplicate(true)
	if data.has("flags"):
		flags = data.flags.duplicate(true)
	if data.has("crafted"):
		crafted = data.crafted.duplicate(true)
	if data.has("weather"):
		weather = String(data.weather)
	if data.has("character"):
		character = data.character.duplicate(true)
	changed.emit()
