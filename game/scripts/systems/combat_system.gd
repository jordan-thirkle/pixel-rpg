extends Node
class_name EverduneCombatSystem

var dungeon_unlocked := false
var dungeon_wins := 0

func enter_dungeon(state: Node, world: Node2D, player: Node2D, enemy_script: Script, ui: CanvasLayer, audio: Node) -> Dictionary:
	if not bool(state.flags.get("glass_orchard_echo", false)):
		return {"ok": false, "message": "The gate is cold. The Orchard memory has not awakened the path yet."}
	if dungeon_unlocked:
		return {"ok": false, "message": "Only quiet stone remains. You have already cleared this chamber."}
	dungeon_unlocked = true
	for p in [Vector2(760,410),Vector2(835,390),Vector2(855,455)]:
		var enemy := enemy_script.new()
		world.add_child(enemy)
		enemy.setup(p, player)
		enemy.defeated.connect(_on_enemy_defeated)
	state.quest_stage = maxi(state.quest_stage, 6)
	audio.cue("gate")
	return {"ok": true, "message": "Three mosslings stir beneath the old stones. The gate remembers a fight."}

func attack(state: Node, player: Node2D, ui: CanvasLayer, audio: Node, vfx_root: Node2D) -> Dictionary:
	player.perform_action("attack")
	var nearest: Node = null
	var distance := 9999.0
	for enemy in player.get_tree().get_nodes_in_group("enemies"):
		var d: float = player.position.distance_to(enemy.position)
		if d < 58.0 and d < distance:
			distance = d
			nearest = enemy
	if nearest == null:
		return {"ok": false, "killed": false, "message": "Your blade cuts the air. Move close to strike."}
	var killed := nearest.take_damage(8 + int(state.skills.get("combat", 1)) * 2)
	state.add_skill_xp("combat", 8)
	audio.cue("hit")
	if killed:
		dungeon_wins += 1
		state.gold += 5
		state.add_xp(12)
		audio.cue("defeat")
		if dungeon_wins >= 3:
			state.quest_stage = maxi(state.quest_stage, 7)
			state._unlock_achievement("sleeping_gate")
			return {"ok": true, "killed": true, "completed": true, "message": "The mosslings retreat. Behind them, the old gate gives a single answering chime."}
	return {"ok": true, "killed": killed, "completed": false, "message": "Hit."}

func _on_enemy_defeated(_enemy: Node) -> void:
	pass
