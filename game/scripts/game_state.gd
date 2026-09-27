extends Node
class_name EverduneGameState

signal changed

const DEFAULT_INVENTORY := {"wood":3,"stone":2,"river_fish":0,"memory_shard":0,"hearthstone":0}
const DEFAULT_SKILLS := {"gathering":1,"fishing":1,"memory":1,"combat":1}
const DEFAULT_SKILL_XP := {"gathering":0,"fishing":0,"memory":0,"combat":0}
const DEFAULT_EQUIPMENT := {"tool":"axe","weapon":"wayfarer_blade","armor":"traveller_coat"}
const DEFAULT_COLLECTIONS := {"silverfin":0,"memory_shard":0,"wood":0,"stone":0}

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
var inventory := DEFAULT_INVENTORY.duplicate(true)
var flags := {}
var crafted := {}
var weather := "Clear"
var character := {"name":"","hair":"dark","coat":"teal"}
var quest_stage := 0
var skills := DEFAULT_SKILLS.duplicate(true)
var skill_xp := DEFAULT_SKILL_XP.duplicate(true)
var equipment := DEFAULT_EQUIPMENT.duplicate(true)
var collections := DEFAULT_COLLECTIONS.duplicate(true)
var achievements := {}

func reset_new_game() -> void:
	day = 1
	hour = 8
	minute = 15
	season = "Spring"
	year = 1
	hp = 100
	max_hp = 100
	energy = 100
	max_energy = 100
	level = 1
	xp = 0
	gold = 25
	echoes = 0
	inventory = DEFAULT_INVENTORY.duplicate(true)
	flags = {}
	crafted = {}
	weather = "Clear"
	character = {"name":"","hair":"dark","coat":"teal"}
	quest_stage = 0
	skills = DEFAULT_SKILLS.duplicate(true)
	skill_xp = DEFAULT_SKILL_XP.duplicate(true)
	equipment = DEFAULT_EQUIPMENT.duplicate(true)
	collections = DEFAULT_COLLECTIONS.duplicate(true)
	achievements = {}
	changed.emit()

func add_item(id: String, amount: int) -> void:
	inventory[id] = int(inventory.get(id, 0)) + amount
	if collections.has(id):
		collections[id] = int(collections[id]) + amount
	changed.emit()

func add_skill_xp(skill: String, amount: int) -> void:
	skill_xp[skill] = int(skill_xp.get(skill, 0)) + amount
	var threshold := 25 + (int(skills.get(skill, 1)) - 1) * 20
	while int(skill_xp[skill]) >= threshold:
		skill_xp[skill] = int(skill_xp[skill]) - threshold
		skills[skill] = int(skills.get(skill, 1)) + 1
		_unlock_achievement("skill_" + skill + "_" + str(skills[skill]))
		threshold = 25 + (int(skills.get(skill, 1)) - 1) * 20
	changed.emit()

func _unlock_achievement(id: String) -> void:
	achievements[id] = true
	changed.emit()

func has_achievement(id: String) -> bool:
	return bool(achievements.get(id, false))

func set_equipment(slot: String, id: String) -> void:
	equipment[slot] = id
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
	if not has_item("wood",3) or not has_item("stone",2) or not has_item("memory_shard",1):
		return false
	remove_item("wood",3)
	remove_item("stone",2)
	remove_item("memory_shard",1)
	inventory["hearthstone"] = int(inventory.get("hearthstone",0)) + 1
	crafted["hearth_lamp"] = int(crafted.get("hearth_lamp",0)) + 1
	_unlock_achievement("first_craft")
	add_skill_xp("memory",10)
	add_xp(20)
	changed.emit()
	return true

func snapshot() -> Dictionary:
	return {
		"day":day,"hour":hour,"minute":minute,"season":season,"year":year,
		"hp":hp,"max_hp":max_hp,"energy":energy,"max_energy":max_energy,
		"level":level,"xp":xp,"gold":gold,"echoes":echoes,
		"inventory":inventory.duplicate(true),"flags":flags.duplicate(true),
		"crafted":crafted.duplicate(true),"weather":weather,
		"character":character.duplicate(true),"quest_stage":quest_stage,
		"skills":skills.duplicate(true),"skill_xp":skill_xp.duplicate(true),
		"equipment":equipment.duplicate(true),"collections":collections.duplicate(true),
		"achievements":achievements.duplicate(true)
	}

func restore(data: Dictionary) -> void:
	for key in ["day","hour","minute","season","year","hp","max_hp","energy","max_energy","level","xp","gold","echoes"]:
		if data.has(key):
			set(key, data[key])
	inventory = _dict_or_default(data,"inventory",DEFAULT_INVENTORY)
	flags = _dict_or_default(data,"flags",{})
	crafted = _dict_or_default(data,"crafted",{})
	weather = String(data.get("weather","Clear"))
	character = _dict_or_default(data,"character",{"name":"","hair":"dark","coat":"teal"})
	quest_stage = int(data.get("quest_stage",0))
	skills = _dict_or_default(data,"skills",DEFAULT_SKILLS)
	skill_xp = _dict_or_default(data,"skill_xp",DEFAULT_SKILL_XP)
	equipment = _dict_or_default(data,"equipment",DEFAULT_EQUIPMENT)
	collections = _dict_or_default(data,"collections",DEFAULT_COLLECTIONS)
	achievements = _dict_or_default(data,"achievements",{})
	changed.emit()

func _dict_or_default(data: Dictionary, key: String, fallback: Dictionary) -> Dictionary:
	var value = data.get(key, fallback)
	return value.duplicate(true) if value is Dictionary else fallback.duplicate(true)
