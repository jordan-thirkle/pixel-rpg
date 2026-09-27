extends Node
class_name EverduneCombatSystem

var dungeon_wins := 0

func enter_dungeon(state: Node, world: Node2D, player: Node2D, enemy_script: Script, ui: CanvasLayer, audio: Node) -> Dictionary:
	if not bool(state.flags.get("glass_orchard_echo", false)):
		return {"ok": false, "message": "The gate is cold. The Orchard memory has not awakened the path yet."}
	if bool(state.flags.get("sleeping_gate_cleared", false)):
		return {"ok": false, "message": "The Sleeping Gate is quiet. Its memory now knows your footsteps."}
	if bool(state.flags.get("sleeping_gate_entered", false)):
		return {"ok": false, "message": "The gate is already awake. The mosslings are still inside."}

	dungeon_wins = 0
	state.set_flag("sleeping_gate_entered", true)
	for spec in [
		{"pos":Vector2(760,410),"hp":18,"speed":36.0,"scale":1.25},
		{"pos":Vector2(835,392),"hp":22,"speed":42.0,"scale":1.4},
		{"pos":Vector2(855,455),"hp":28,"speed":30.0,"scale":1.55}
	]:
		var enemy := enemy_script.new()
		world.add_child(enemy)
		enemy.setup(spec.pos, player)
		enemy.configure_variant(int(spec.hp), float(spec.speed), float(spec.scale))
		enemy.defeated.connect(_on_enemy_defeated)
	state.quest_stage = maxi(state.quest_stage, 6)
	audio.cue("gate_open")
	return {"ok": true, "message": "Three mosslings stir beneath the old stones. The gate remembers a fight."}

func attack(state: Node, player: Node2D, ui: CanvasLayer, audio: Node, vfx_root: Node2D) -> Dictionary:
	if not bool(state.flags.get("sleeping_gate_entered", false)):
		return {"ok": false, "killed": false, "message": "There is nothing to fight here."}
	if bool(state.flags.get("sleeping_gate_cleared", false)):
		return {"ok": false, "killed": false, "message": "The chamber has fallen silent."}

	player.perform_action("attack")
	audio.cue("swing")
	var nearest: Node = null
	var distance := 9999.0
	for enemy in player.get_tree().get_nodes_in_group("enemies"):
		var d: float = player.position.distance_to(enemy.position)
		if d < 62.0 and d < distance:
			distance = d
			nearest = enemy
	if nearest == null:
		return {"ok": false, "killed": false, "message": "Your blade cuts the air. Move close to strike."}

	var damage := 8 + int(state.skills.get("combat", 1)) * 2
	if int(state.combat_streak) >= 2:
		damage += 2
	var killed := nearest.take_damage(damage)
	state.combat_streak = int(state.combat_streak) + 1
	state.add_skill_xp("combat", 8)
	audio.cue("hit")
	if killed:
		dungeon_wins += 1
		state.gold += 5
		state.add_xp(12)
		state.combat_streak = 0
		audio.cue("defeat")
		if dungeon_wins >= 3:
			state.quest_stage = maxi(state.quest_stage, 7)
			state._unlock_achievement("sleeping_gate")
			state.set_flag("sleeping_gate_cleared", true)
			state.set_flag("sleeping_gate_entered", false)
			return {"ok": true, "killed": true, "completed": true, "message": "The mosslings retreat. Behind them, the old gate gives a single answering chime."}
	return {"ok": true, "killed": killed, "completed": false, "message": "Hit."}

func _on_enemy_defeated(_enemy: Node) -> void:
	pass
