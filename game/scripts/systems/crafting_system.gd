extends Node
class_name EverduneCraftingSystem

const RECIPES := {
	"hearth_lamp": {
		"cost": {"wood": 3, "stone": 2, "memory_shard": 1},
		"output": "hearthstone",
		"amount": 1,
		"display": "hearth_lamp"
	},
	"fisher_rack": {
		"cost": {"timber": 2, "silverfin": 1},
		"output": "decor",
		"amount": 1,
		"display": "fisher_rack"
	},
	"herb_shelf": {
		"cost": {"wood": 2, "wildflower": 2, "herbs": 1},
		"output": "decor",
		"amount": 1,
		"display": "herb_shelf"
	},
	"archive_case": {
		"cost": {"wood": 3, "antique": 1, "memory_shard": 1},
		"output": "decor",
		"amount": 1,
		"display": "archive_case"
	}
}

func craft_hearth_lamp(state: Node) -> bool:
	return craft("hearth_lamp", state)

func craft(recipe_id: String, state: Node) -> bool:
	var recipe: Dictionary = RECIPES.get(recipe_id, {})
	if recipe.is_empty():
		return false
	var costs: Dictionary = recipe.cost
	for item in costs.keys():
		if not state.has_item(String(item), int(costs[item])):
			return false
	for item in costs.keys():
		state.remove_item(String(item), int(costs[item]))
	state.add_item(String(recipe.output), int(recipe.amount))
	if not state.crafted.has(recipe_id):
		state.crafted[recipe_id] = 0
	state.crafted[recipe_id] = int(state.crafted[recipe_id]) + 1
	state.add_home_display(String(recipe.display))
	state.record_activity("crafting")
	state.add_skill_xp("crafting", 14)
	if recipe_id == "hearth_lamp":
		if not state.has_achievement("first_craft"):
			state._unlock_achievement("first_craft")
		state.add_skill_xp("memory", 10)
	state.add_xp(8)
	state.set_flag("crafted_" + recipe_id, true)
	state.changed.emit()
	return true

func next_available_recipe(state: Node) -> String:
	for id in ["hearth_lamp", "fisher_rack", "herb_shelf", "archive_case"]:
		if craftable(id, state):
			return id
	return ""

func craftable(recipe_id: String, state: Node) -> bool:
	var recipe: Dictionary = RECIPES.get(recipe_id, {})
	if recipe.is_empty():
		return false
	for item in recipe.cost.keys():
		if not state.has_item(String(item), int(recipe.cost[item])):
			return false
	return true
