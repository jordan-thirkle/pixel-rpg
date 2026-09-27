extends CharacterBody2D
class_name EverdunePlayer

var state: Node
var speed := 145.0
var facing := Vector2.DOWN
var bob := 0.0

func _ready() -> void:
	z_index = 20
	queue_redraw()

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		(1.0 if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)) else 0.0),
		(1.0 if (Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) else 0.0)
	)
	if input_vector.length() > 0.0:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		facing = input_vector
		if state:
			state.energy = maxf(0.0, state.energy - delta * 0.7)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 8.0 * delta)
	bob += delta * (8.0 if input_vector.length() > 0.0 else 2.0)
	var previous_position := position
	move_and_slide()
	var in_river := position.x > 600.0 and position.x < 850.0 and position.y > 60.0 and position.y < 490.0
	var on_bridge := position.x > 575.0 and position.x < 649.0 and position.y > 248.0 and position.y < 310.0
	if in_river and not on_bridge:
		position = previous_position
		velocity = Vector2.ZERO
	position.x = clampf(position.x, 54.0, 906.0)
	position.y = clampf(position.y, 72.0, 488.0)
	queue_redraw()

func _draw() -> void:
	var lift := sin(bob) * 1.5
	draw_ellipse(Vector2(0, 10), Vector2(9, 4), Color("#17241e80"))
	draw_rect(Rect2(-7, -3 + lift, 14, 16), Color("#284b46"))
	draw_rect(Rect2(-6, 1 + lift, 12, 12), Color("#3d6b60"))
	draw_rect(Rect2(-6, -12 + lift, 12, 10), Color("#d7aa7a"))
	draw_rect(Rect2(-6, -13 + lift, 12, 5), Color("#49352e"))
	draw_rect(Rect2(-4, -8 + lift, 2, 2), Color("#242326"))
	draw_rect(Rect2(2, -8 + lift, 2, 2), Color("#242326"))
	draw_rect(Rect2(-8, -1 + lift, 16, 3), Color("#c77d5a"))
	draw_rect(Rect2(-7, 13 + lift, 5, 4), Color("#352c2b"))
	draw_rect(Rect2(2, 13 + lift, 5, 4), Color("#352c2b"))

func draw_ellipse(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for i in range(24):
		var a := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(a) * radii.x, sin(a) * radii.y))
	draw_colored_polygon(points, color)
