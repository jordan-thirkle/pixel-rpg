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
	if not bool(state.flags.get("old_road_echo", false)):
		return {"ok": false, "message": "The old road is only a road. Listen to its memory first."}
	if not bool(state.flags.get("mapped_old_road", false)):
		state.add_item("map_fragment", 1)
		state.set_flag("mapped_old_road", true)
		state.record_world_memory("old_road_mapped", "A safer footpath now appears on the Wayfarer's map.")
		return _finish("wayfinding", state, "wayfinding", 18, "You sketch the old road from memory. A shortcut appears on your map.")
	state.add_skill_xp("wayfinding", 5)
	return {"ok": true, "message": "You walk the old road slowly. You notice another landmark you had missed before."}

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
