extends Area2D
class_name EverduneEnemy

signal defeated(enemy)

var enemy_id := "mossling"
var hp := 18
var max_hp := 18
var speed := 35.0
var visual: Sprite2D
var target: Node2D
var attack_cooldown := 0.0
var attack_windup := 0.0
var knockback := Vector2.ZERO
var flash_time := 0.0
var telegraph: Polygon2D

const SLIME := preload("res://assets/enemy_slime.svg")

func setup(at: Vector2, player_ref: Node2D) -> void:
	position = at
	target = player_ref
	visual = Sprite2D.new()
	visual.texture = SLIME
	visual.region_enabled = true
	visual.region_rect = Rect2(0,0,32,32)
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	visual.scale = Vector2(1.35,1.35)
	add_child(visual)
	telegraph = Polygon2D.new()
	var points := PackedVector2Array()
	for i in range(20):
		var a := TAU * float(i) / 20.0
		points.append(Vector2(cos(a),sin(a)) * 23.0)
	telegraph.polygon = points
	telegraph.color = Color(0.82,0.40,0.26,0.0)
	telegraph.z_index = -1
	add_child(telegraph)
	add_to_group("enemies")

func take_damage(amount: int) -> bool:
	hp -= amount
	flash_time = 0.12
	if target:
		knockback = target.position.direction_to(position) * 46.0
	if hp <= 0:
		defeated.emit(self)
		queue_free()
		return true
	return false

func _process(delta: float) -> void:
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	flash_time = maxf(0.0, flash_time - delta)
	if attack_windup > 0.0:
		attack_windup -= delta
		if telegraph:
			telegraph.color.a = 0.25 + sin(Time.get_ticks_msec() * 0.025) * 0.15
		if attack_windup <= 0.0:
			_strike()
	elif telegraph:
		telegraph.color.a = 0.0

	if knockback.length() > 0.5:
		position += knockback * delta
		knockback = knockback.move_toward(Vector2.ZERO, 220.0 * delta)
	if target == null:
		return

	var d := position.distance_to(target.position)
	if d < 150.0 and d > 28.0 and attack_windup <= 0.0:
		position += position.direction_to(target.position) * speed * delta
	if visual:
		visual.region_rect = Rect2((int(Time.get_ticks_msec()/180) % 3) * 32, 0, 32, 32)
		visual.modulate = Color("#ffffff") if flash_time > 0.0 else Color("#b8d0b2")
	if d < 30.0 and attack_cooldown <= 0.0 and attack_windup <= 0.0:
		attack_cooldown = 1.4
		attack_windup = 0.32
		if visual:
			visual.scale = Vector2(1.5,1.2)

func _strike() -> void:
	if target and position.distance_to(target.position) < 42.0 and target.has_method("take_enemy_hit"):
		target.take_enemy_hit(4)
	if visual:
		var tween := create_tween()
		tween.tween_property(visual,"scale",Vector2(1.35,1.35),0.12)
