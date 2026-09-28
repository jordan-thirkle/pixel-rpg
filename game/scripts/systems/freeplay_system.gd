extends Node
class_name EverduneFreeplaySystem

signal activity_completed(id: String, message: String)

func perform(id: String, state: Node) -> Dictionary:
	match id:
		"cookfire":
			return _cook(state)
		"garden":
			return _garden(state)
		"wayfinding":
			return _wayfind(state)
		"workbench":
			return _build(state)
		"decorating":
			return _decorate(state)
		"market":
			return _market(state)
		"orchard_care":
			return _orchard_care(state)
		"archaeology":
			return _archaeology(state)
		"survey":
			return _survey(state)
		_:
			return {"ok": false, "message": "There is nothing to do here yet."}

func _finish(id: String, state: Node, skill: String, xp: int, message: String) -> Dictionary:
	state.record_activity(id)
	state.add_skill_xp(skill, xp)
	state.add_xp(maxi(2, int(xp / 2)))
	activity_completed.emit(id, message)
	return {"ok": true, "message": message}

func _cook(state: Node) -> Dictionary:
	if state.has_item("river_fish"):
		state.remove_item("river_fish", 1)
	elif state.has_item("berries", 2) and state.has_item("herbs"):
		state.remove_item("berries", 2)
		state.remove_item("herbs", 1)
	else:
		return {"ok": false, "message": "Bring a fish, or 2 berries and an herb, and the hearth can make dinner."}
	state.add_item("cooked_meal", 1)
	state.energy = mini(state.max_energy, state.energy + 18)
	state.set_flag("cooked_first_meal", true)
	state.add_home_display("first_meal")
	return _finish("cookfire", state, "cooking", 14, "You make a warm meal. The house smells lived-in again.")

func _garden(state: Node) -> Dictionary:
	if state.garden_ready:
		state.garden_ready = false
		state.garden_planted_day = 0
		var yield_amount := 2 + mini(2, int(state.skills.get("farming",1)) / 4)
		state.add_item("berries", yield_amount)
		state.add_item("herbs", 1)
		state.set_flag("garden_harvested", true)
		return _finish("garden_harvest", state, "farming", 18, "You harvest the garden. A little patch of Larkmere is now feeding your home.")
	if state.garden_planted_day > 0:
		return {"ok": false, "message": "The garden is growing. Come back after another day has passed."}
	if not state.has_item("seeds"):
		return {"ok": false, "message": "You have no seeds. Forage around Briarwood and the valley edge."}
	state.remove_item("seeds", 1)
	state.garden_planted_day = state.day
	state.garden_ready = false
	state.set_flag("garden_planted", true)
	return _finish("garden", state, "farming", 8, "You plant a seed and water the soil. It will grow while you get on with your day.")

func _wayfind(state: Node) -> Dictionary:
	if state.activity_done_today("wayfinding") and bool(state.flags.get("mapped_old_road", false)):
		return {"ok": false, "message": "You've already traced the old road today. Let the valley change before you trace it again."}
	if not bool(state.flags.get("old_road_echo", false)):
		return {"ok": false, "message": "The old road is only a road. Listen to its memory first."}
	if not bool(state.flags.get("mapped_old_road", false)):
		state.add_item("map_fragment", 1)
		state.set_flag("mapped_old_road", true)
		state.record_world_memory("old_road_mapped", "A safer footpath now appears on the Wayfarer's map.")
		return _finish("wayfinding", state, "wayfinding", 18, "You sketch the old road from memory. A shortcut appears on your map.")
	state.add_skill_xp("wayfinding", 5)
	state.add_xp(3)
	state.record_activity("wayfinding")
	return {"ok": true, "message": "You walk the old road slowly. You notice another landmark you had missed before."}

func _market(state: Node) -> Dictionary:
	if state.activity_done_today("market"):
		return {"ok": false, "message": "Mara has put the market shutters up for today. Come back tomorrow."}
	var traded := false
	if state.has_item("silverfin"):
		state.remove_item("silverfin", 1)
		traded = true
	elif state.has_item("river_fish", 2):
		state.remove_item("river_fish", 2)
		traded = true
	elif state.has_item("berries", 3) and state.has_item("herbs", 1):
		state.remove_item("berries", 3)
		state.remove_item("herbs", 1)
		traded = true
	if not traded:
		return {"ok": false, "message": "Bring a silverfin, two river fish, or 3 berries and an herb to trade."}
	state.add_item("trade_token", 1)
	state.add_item("seeds", 2)
	state.adjust_relationship("mara", 1)
	state.remember_npc("mara", "market_trade_day_" + str(state.day))
	state.record_world_memory("market_trade", "The Hearthfall market now knows what you bring back from the valley.")
	return _finish("market", state, "gathering", 10, "Mara trades fairly. You leave with seeds and the quiet feeling that you belong here.")

func _orchard_care(state: Node) -> Dictionary:
	if not bool(state.flags.get("glass_orchard_echo", false)):
		return {"ok": false, "message": "The orchard is still only a memory. Listen to its Echo first."}
	if state.activity_done_today("orchard_care"):
		return {"ok": false, "message": "The orchard is tended for today. Come back when the light changes."}
	var yield_amount := 1 + mini(2, int(state.skills.get("farming", 1)) / 3)
	state.add_item("fruit", yield_amount)
	state.set_flag("orchard_tended", true)
	state.record_world_memory("orchard_tended", "The Glass Orchard is producing fruit again.")
	return _finish("orchard_care", state, "farming", 16, "You prune the old branches and clear the glassy roots. A few impossible little fruits return.")

func _archaeology(state: Node) -> Dictionary:
	if not bool(state.flags.get("bellroot_route", false)):
		return {"ok": false, "message": "You need the miners' remembered route before the old stones make sense."}
	if state.activity_done_today("archaeology"):
		return {"ok": false, "message": "You've searched these stones carefully enough for one day."}
	var mining_level := int(state.skills.get("mining", 1))
	if mining_level < 2:
		return {"ok": false, "message": "Reach Mining 2 to recognise what the old stones are hiding."}
	state.add_item("antique", 1)
	state.add_skill_xp("memory", 10)
	state.record_activity("archaeology")
	state.record_world_memory("bellroot_archaeology", "You are beginning to recover objects rather than only ore from Bellroot.")
	state.set_flag("archaeology_started", true)
	state.add_xp(14 + mining_level)
	activity_completed.emit("archaeology", "You brush the dust from an old tool-marked token. Bellroot was a settlement long before it was a mine.")
	return {"ok": true, "message": "You recover an old miner's token. Bellroot feels less like a dungeon and more like a place where people once lived."}

func _survey(state: Node) -> Dictionary:
	if not bool(state.flags.get("mapped_old_road", false)):
		return {"ok": false, "message": "Map the Old Road before trying to survey the valley's forgotten edges."}
	if state.activity_done_today("survey"):
		return {"ok": false, "message": "You've taken enough notes for one day. The landmarks need time to reveal themselves."}
	state.add_item("map_fragment", 1)
	state.add_skill_xp("wayfinding", 14)
	state.add_skill_xp("memory", 6)
	state.record_activity("survey")
	state.record_world_memory("hollow_steps_surveyed", "Your map now includes a route toward the Hollow Steps.")
	state.set_flag("hollow_steps_known", true)
	state.add_xp(10)
	return {"ok": true, "message": "You survey the valley edge and mark a staircase hidden behind the old road. Another route now belongs to you."}

func _build(state: Node) -> Dictionary:
	if state.home_level >= 3:
		return {"ok": false, "message": "Your home already has every Hearthfall improvement in this slice."}
	if not state.has_item("wood", 5) or not state.has_item("stone", 3):
		return {"ok": false, "message": "The workbench needs 5 Wood and 3 Stone."}
	state.remove_item("wood",5)
	state.remove_item("stone",3)
	state.home_level += 1
	state.add_home_display("workbench")
	state.record_world_memory("hearthfall_workbench", "A proper workbench now anchors the home.")
	if state.home_level == 2:
		state.set_flag("home_workshop", true)
		return _finish("building", state, "building", 24, "You build a proper workbench. Home is becoming a place where projects can begin.")
	return _finish("building", state, "building", 30, "You reinforce the workshop. Your home is starting to feel like your own.")

func _decorate(state: Node) -> Dictionary:
	if state.has_item("silverfin") and not bool(state.flags.get("silverfin_displayed", false)):
		state.remove_item("silverfin", 1)
		state.add_home_display("silverfin_trophy")
		state.set_flag("silverfin_displayed", true)
		return _finish("decorating", state, "building", 12, "You mount your first silverfin. The wall now tells a story about where you spent your evening.")
	if state.has_item("map_fragment") and not bool(state.flags.get("map_displayed", false)):
		state.remove_item("map_fragment", 1)
		state.add_home_display("old_road_map")
		state.set_flag("map_displayed", true)
		return _finish("decorating", state, "building", 12, "You pin the old road map beside the hearth. Your home is starting to become a record of your life.")
	if state.has_item("decor") and not bool(state.flags.get("decor_displayed", false)):
		state.remove_item("decor",1)
		state.add_home_display("found_decor")
		state.set_flag("decor_displayed", true)
		return _finish("decorating", state, "building", 10, "You place the little found object somewhere you will see it every day.")
	return {"ok": false, "message": "Bring something worth displaying home: a rare fish, map fragment, or found decoration."}
