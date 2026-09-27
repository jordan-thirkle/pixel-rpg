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
	add_to_group("enemies")

func take_damage(amount: int) -> bool:
	hp -= amount
	if hp <= 0:
		defeated.emit(self)
		queue_free()
		return true
	return false

func _process(delta: float) -> void:
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	if target == null:
		return
	var d := position.distance_to(target.position)
	if d < 150.0 and d > 28.0:
		position += position.direction_to(target.position) * speed * delta
	if visual:
		visual.region_rect = Rect2((int(Time.get_ticks_msec()/180) % 3) * 32, 0, 32, 32)
	if d < 30.0 and attack_cooldown <= 0.0:
		attack_cooldown = 1.4
		if target.has_method("take_enemy_hit"):
			target.take_enemy_hit(4)
