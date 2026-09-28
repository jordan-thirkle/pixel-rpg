extends Node
class_name EverduneGameState

signal changed

const DEFAULT_INVENTORY := {"wood":3,"stone":2,"ore":0,"timber":0,"river_fish":0,"silverfin":0,"memory_shard":0,"hearthstone":0,"berries":2,"mushrooms":1,"herbs":1,"wildflower":0,"seeds":3,"fruit":0,"cooked_meal":0,"map_fragment":0,"decor":0,"antique":0,"trade_token":0}
const DEFAULT_SKILLS := {"gathering":1,"woodcutting":1,"mining":1,"foraging":1,"fishing":1,"farming":1,"cooking":1,"crafting":1,"building":1,"wayfinding":1,"memory":1,"combat":1}
const DEFAULT_SKILL_XP := {"gathering":0,"woodcutting":0,"mining":0,"foraging":0,"fishing":0,"farming":0,"cooking":0,"crafting":0,"building":0,"wayfinding":0,"memory":0,"combat":0}
const DEFAULT_EQUIPMENT := {"tool":"axe","weapon":"wayfarer_blade","armor":"traveller_coat"}
const DEFAULT_COLLECTIONS := {"silverfin":0,"memory_shard":0,"wood":0,"stone":0,"ore":0,"timber":0,"berries":0,"mushrooms":0,"herbs":0,"wildflower":0,"fruit":0,"cooked_meal":0,"map_fragment":0,"decor":0,"antique":0}

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
var fish_luck := 0
var home_returns := 0
var relationship_mara := 0
var combat_streak := 0
var activity_counts := {}
var activity_last_day := {}
var world_memory := {}
var npc_memories := {}
var relationships := {"mara":0,"rowan":0}
var home_level := 1
var home_display_items := []
var garden_planted_day := 0
var garden_ready := false

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
	fish_luck = 0
	home_returns = 0
	relationship_mara = 0
	combat_streak = 0
	activity_counts = {}
	activity_last_day = {}
	world_memory = {}
	npc_memories = {}
	relationships = {"mara":0,"rowan":0}
	home_level = 1
	home_display_items = []
	garden_planted_day = 0
	garden_ready = false
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

func record_activity(id: String) -> void:
	activity_counts[id] = int(activity_counts.get(id, 0)) + 1
	activity_last_day[id] = day
	if int(activity_counts[id]) == 1:
		set_flag("activity_" + id, true)
	var count := int(activity_counts[id])
	if count == 5:
		set_flag("activity_" + id + "_established", true)
	if count == 10:
		set_flag("activity_" + id + "_mastered", true)
	changed.emit()

func activity_count(id: String) -> int:
	return int(activity_counts.get(id, 0))

func activity_done_today(id: String) -> bool:
	return int(activity_last_day.get(id, 0)) == day

func adjust_relationship(npc_id: String, amount: int) -> int:
	var next := clampi(int(relationships.get(npc_id, 0)) + amount, 0, 10)
	relationships[npc_id] = next
	if npc_id == "mara":
		relationship_mara = next
	changed.emit()
	return next

func relationship(npc_id: String) -> int:
	if npc_id == "mara":
		return maxi(int(relationships.get("mara", 0)), relationship_mara)
	return int(relationships.get(npc_id, 0))

func home_identity() -> String:
	var scores := {
		"Fisher": activity_count("fishing"),
		"Gatherer": activity_count("foraging") + activity_count("woodcutting"),
		"Builder": activity_count("building") + activity_count("decorating"),
		"Farmer": activity_count("garden") + activity_count("garden_harvest"),
		"Wayfinder": activity_count("wayfinding"),
		"Keeper of Echoes": activity_count("echo_place") + activity_count("echo_creature")
	}
	var best := "Wayfarer"
	var best_score := 0
	for key in scores.keys():
		if int(scores[key]) > best_score:
			best = String(key)
			best_score = int(scores[key])
	return best

func record_world_memory(id: String, detail: String = "") -> void:
	world_memory[id] = detail if not detail.is_empty() else true
	set_flag("world_" + id, true)

func remember_npc(npc_id: String, memory_id: String) -> void:
	var memories: Array = npc_memories.get(npc_id, [])
	if memory_id not in memories:
		memories.append(memory_id)
	npc_memories[npc_id] = memories
	changed.emit()

func add_home_display(item_id: String) -> void:
	if item_id not in home_display_items:
		home_display_items.append(item_id)
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
		_unlock_achievement("level_" + str(level))
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
		season = _season_for_day(day)
		if garden_planted_day > 0 and day > garden_planted_day:
			garden_ready = true
	changed.emit()

func _season_for_day(value: int) -> String:
	var index := int(floor(float(maxi(1, value) - 1) / 7.0)) % 4
	return ["Spring","Summer","Autumn","Winter"][index]

func craft_hearth_lamp() -> bool:
	if not has_item("wood",3) or not has_item("stone",2) or not has_item("memory_shard",1):
		return false
	remove_item("wood",3)
	remove_item("stone",2)
	remove_item("memory_shard",1)
	inventory["hearthstone"] = int(inventory.get("hearthstone",0)) + 1
	crafted["hearth_lamp"] = int(crafted.get("hearth_lamp",0)) + 1
	add_home_display("hearth_lamp")
	_unlock_achievement("first_craft")
	add_skill_xp("crafting",10)
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
		"achievements":achievements.duplicate(true), "fish_luck":fish_luck,
		"home_returns":home_returns, "relationship_mara":relationship_mara, "combat_streak":combat_streak,
		"activity_counts":activity_counts.duplicate(true),"activity_last_day":activity_last_day.duplicate(true),"world_memory":world_memory.duplicate(true),
		"npc_memories":npc_memories.duplicate(true),"relationships":relationships.duplicate(true),"relationship_mara":relationship_mara,"home_level":home_level,
		"home_display_items":home_display_items.duplicate(true),"garden_planted_day":garden_planted_day,
		"garden_ready":garden_ready
	}

func restore(data: Dictionary) -> void:
	for key in ["day","hour","minute","season","year","hp","max_hp","energy","max_energy","level","xp","gold","echoes"]:
		if data.has(key):
			set(key, data[key])
	inventory = _merge_defaults(data,"inventory",DEFAULT_INVENTORY)
	flags = _dict_or_default(data,"flags",{})
	crafted = _dict_or_default(data,"crafted",{})
	weather = String(data.get("weather","Clear"))
	character = _dict_or_default(data,"character",{"name":"","hair":"dark","coat":"teal"})
	quest_stage = int(data.get("quest_stage",0))
	skills = _merge_defaults(data,"skills",DEFAULT_SKILLS)
	skill_xp = _merge_defaults(data,"skill_xp",DEFAULT_SKILL_XP)
	equipment = _merge_defaults(data,"equipment",DEFAULT_EQUIPMENT)
	collections = _merge_defaults(data,"collections",DEFAULT_COLLECTIONS)
	achievements = _dict_or_default(data,"achievements",{})
	fish_luck = int(data.get("fish_luck",0))
	home_returns = int(data.get("home_returns",0))
	relationship_mara = int(data.get("relationship_mara",0))
	combat_streak = int(data.get("combat_streak",0))
	activity_counts = _dict_or_default(data,"activity_counts",{})
	activity_last_day = _dict_or_default(data,"activity_last_day",{})
	world_memory = _dict_or_default(data,"world_memory",{})
	npc_memories = _dict_or_default(data,"npc_memories",{})
	relationships = _dict_or_default(data,"relationships",{"mara":int(data.get("relationship_mara",0)),"rowan":0})
	relationship_mara = int(data.get("relationship_mara", relationships.get("mara",0)))
	relationships["mara"] = relationship_mara
	home_level = int(data.get("home_level",1))
	home_display_items = data.get("home_display_items",[]).duplicate(true) if data.get("home_display_items",[]) is Array else []
	garden_planted_day = int(data.get("garden_planted_day",0))
	garden_ready = bool(data.get("garden_ready",false))
	changed.emit()

func _merge_defaults(data: Dictionary, key: String, fallback: Dictionary) -> Dictionary:
	var value = _dict_or_default(data,key,{})
	var merged := fallback.duplicate(true)
	for item in value.keys():
		merged[item] = value[item]
	return merged

func _dict_or_default(data: Dictionary, key: String, fallback: Dictionary) -> Dictionary:
	var value = data.get(key, fallback)
	return value.duplicate(true) if value is Dictionary else fallback.duplicate(true)
