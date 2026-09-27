extends RefCounted
class_name EverduneSaveTest

static func assert_round_trip(save_system: Node, state_script: Script, player_script: Script) -> bool:
	var state := state_script.new()
	state.character["name"] = "Regression Wayfarer"
	state.add_item("wood", 7)
	state.set_flag("old_road_echo", true)
	state.quest_stage = 5
	var snapshot := state.snapshot()
	var restored := state_script.new()
	restored.restore(snapshot)
	assert restored.character.name == "Regression Wayfarer"
	assert int(restored.inventory.wood) == 10
	assert bool(restored.flags.old_road_echo)
	assert restored.quest_stage == 5
	return true
