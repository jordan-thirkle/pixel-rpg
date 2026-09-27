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
var hit_stun := 0.0
var telegraph: Polygon2D
var health_fill: ColorRect
var visual_base_scale := Vector2.ONE

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
		points.append(Vector2(cos(a),sin(a)) * 27.0)
	telegraph.polygon = points
	telegraph.color = Color("#d37a5f")
	telegraph.modulate.a = 0.0
	telegraph.z_index = -1
	add_child(telegraph)
	_build_health_bar()
	add_to_group("enemies")

func configure_variant(health: int, move_speed: float, visual_scale: float) -> void:
	max_hp = health
	hp = health
	speed = move_speed
	if visual:
		visual_base_scale = Vector2.ONE * visual_scale
		visual.scale = visual_base_scale
	_update_health_bar()

func _build_health_bar() -> void:
	var bg := ColorRect.new()
	bg.position = Vector2(-20,-34)
	bg.size = Vector2(40,4)
	bg.color = Color("#292628")
	add_child(bg)
	health_fill = ColorRect.new()
	health_fill.position = Vector2(-19,-33)
	health_fill.size = Vector2(38,2)
	health_fill.color = Color("#b86a55")
	add_child(health_fill)

func _update_health_bar() -> void:
	if health_fill:
		health_fill.size.x = 38.0 * clampf(float(hp) / float(maxi(max_hp,1)),0.0,1.0)

func take_damage(amount: int) -> bool:
	hp = maxi(0, hp - amount)
	flash_time = 0.12
	hit_stun = 0.16
	attack_windup = 0.0
	if target:
		knockback = target.position.direction_to(position) * (54.0 + amount * 1.5)
	_update_health_bar()
	if hp <= 0:
		defeated.emit(self)
		queue_free()
		return true
	return false

func _process(delta: float) -> void:
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	flash_time = maxf(0.0, flash_time - delta)
	hit_stun = maxf(0.0, hit_stun - delta)

	if attack_windup > 0.0:
		attack_windup -= delta
		if telegraph:
			telegraph.modulate.a = 0.26 + sin(Time.get_ticks_msec() * 0.025) * 0.12
		if attack_windup <= 0.0:
			_strike()
	elif telegraph:
		telegraph.modulate.a = 0.0

	if knockback.length() > 0.5:
		position += knockback * delta
		knockback = knockback.move_toward(Vector2.ZERO, 250.0 * delta)
	if target == null or hit_stun > 0.0:
		return

	var d := position.distance_to(target.position)
	if d < 150.0 and d > 30.0 and attack_windup <= 0.0:
		position += position.direction_to(target.position) * speed * delta
	if visual:
		var frame := int(Time.get_ticks_msec()/150) % 3
		visual.region_rect = Rect2(frame * 32, 0, 32, 32)
		visual.modulate = Color("#ffffff") if flash_time > 0.0 else Color("#b8d0b2")
	if d < 34.0 and attack_cooldown <= 0.0 and attack_windup <= 0.0:
		attack_cooldown = 1.4
		attack_windup = 0.36
		if visual:
			var tween := create_tween()
			tween.tween_property(visual,"scale",visual_base_scale * Vector2(1.12,0.88),0.12)
			tween.tween_property(visual,"scale",visual_base_scale,0.12)

func _strike() -> void:
	if target and position.distance_to(target.position) < 46.0 and target.has_method("take_enemy_hit"):
		target.take_enemy_hit(4)
