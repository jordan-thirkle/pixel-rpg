extends SceneTree

const STATE := preload("res://scripts/game_state.gd")
const SAVE := preload("res://scripts/save_system.gd")

func _initialize() -> void:
	var save := SAVE.new()
	var legacy := {
		"inventory":{"wood":3,"stone":2,"river_fish":0,"memory_shard":0,"hearthstone":0},
		"flags":{},
		"crafted":{},
		"weather":"Clear",
		"character":{"name":"Legacy","hair":"dark","coat":"teal"},
		"quest_stage":0,
		"skills":{"gathering":1,"fishing":1,"memory":1,"combat":1},
		"skill_xp":{"gathering":0,"fishing":0,"memory":0,"combat":0},
		"equipment":{"tool":"axe","weapon":"wayfarer_blade","armor":"traveller_coat"}
	}
	var migrated: Dictionary = save.migrate_state_for_test(legacy, 1)
	assert migrated.has("collections")
	assert migrated.has("achievements")
	var state := STATE.new()
	state.restore(migrated)
	assert state.collections.has("wood")
	assert state.achievements is Dictionary
	print("Everdune save migration checks passed.")
	quit()
