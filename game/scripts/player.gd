extends CharacterBody2D
class_name EverdunePlayer

const BODY := preload("res://assets/player_body.svg")
const HAIR := preload("res://assets/player_hair.svg")
const COAT := preload("res://assets/player_coat.svg")
const TOOLS := preload("res://assets/hero_tools.svg")

var state: Node
var speed := 145.0
var acceleration := 1050.0
var braking := 1350.0
var facing := Vector2.DOWN
var bob := 0.0
var action_time := 0.0
var action_kind := ""
var tool_sprite: Sprite2D
var body_sprite: Sprite2D
var hair_sprite: Sprite2D
var coat_sprite: Sprite2D
var equipment := "axe"
var step_phase := 0.0
var last_moving := false

const CHARACTER_SCALE := Vector2(1.75, 1.75)

func _ready() -> void:
	z_index = 20
	_build_layers()
	queue_redraw()

func _build_layers() -> void:
	body_sprite = _atlas_sprite(BODY)
	hair_sprite = _atlas_sprite(HAIR)
	coat_sprite = _atlas_sprite(COAT)
	tool_sprite = _atlas_sprite(TOOLS)
	tool_sprite.visible = false
	add_child(body_sprite)
	add_child(coat_sprite)
	add_child(hair_sprite)
	add_child(tool_sprite)
	_apply_customisation()

func _atlas_sprite(texture: Texture2D) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = texture
	s.region_enabled = true
	s.region_rect = Rect2(0,0,32,32)
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	s.scale = CHARACTER_SCALE
	return s

func _process(delta: float) -> void:
	var moving := velocity.length() > 8.0
	if moving:
		bob += delta * 10.0
		step_phase = fmod(step_phase + delta * 7.5, TAU)
	else:
		bob += delta * 2.0

	action_time = maxf(0.0, action_time - delta)
	var frame := int(floor(fmod(bob * (0.82 if moving else 0.22), 4.0)))
	var row := _direction_row()
	var rect := Rect2(frame * 32, row * 32, 32, 32)
	if body_sprite: body_sprite.region_rect = rect
	if hair_sprite: hair_sprite.region_rect = rect
	if coat_sprite: coat_sprite.region_rect = rect
	if tool_sprite:
		tool_sprite.region_rect = rect
		tool_sprite.visible = action_time > 0.0
		tool_sprite.modulate = Color("#d9c48a") if equipment == "axe" else Color("#a9c3c6")

	# Tiny grounded motion makes movement feel less mechanically flat.
	var stride := sin(step_phase) * (0.8 if moving else 0.0)
	for sprite in [body_sprite, coat_sprite, hair_sprite]:
		if sprite:
			sprite.position.y = stride
	if tool_sprite:
		tool_sprite.position.y = stride

	last_moving = moving

func _direction_row() -> int:
	if absf(facing.x) > absf(facing.y):
		return 1 if facing.x > 0.0 else 3
	return 0 if facing.y > 0.0 else 2

func perform_action(kind: String) -> void:
	action_kind = kind
	action_time = 0.42
	bob += 0.8

func take_enemy_hit(amount: int) -> void:
	if state:
		state.hp = maxi(0, state.hp - amount)
		if state.hp <= 0:
			state.hp = state.max_hp
			position = Vector2(480, 290)
		state.changed.emit()

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		(1.0 if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)) else 0.0),
		(1.0 if (Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) else 0.0)
	)
	if input_vector.length() > 0.0:
		input_vector = input_vector.normalized()
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		facing = input_vector
		if state:
			state.energy = maxf(0.0, state.energy - delta * 0.7)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, braking * delta)

	move_and_slide()

	# The Hearthfall world owns its physical boundaries; player logic only keeps us inside the authored viewport.
	position.x = clampf(position.x, 54.0, 906.0)
	position.y = clampf(position.y, 54.0, 486.0)

func _apply_customisation() -> void:
	if state == null:
		return
	var hair := String(state.character.get("hair", "dark"))
	var coat := String(state.character.get("coat", "teal"))
	var hair_colors := {"dark":Color("#4b3730"),"ember":Color("#7d4938"),"gold":Color("#9a713e")}
	var coat_colors := {"teal":Color("#355f59"),"wine":Color("#704f65"),"ochre":Color("#80633b")}
	if hair_sprite: hair_sprite.modulate = hair_colors.get(hair, Color.WHITE)
	if coat_sprite: coat_sprite.modulate = coat_colors.get(coat, Color.WHITE)

func refresh_customisation() -> void:
	_apply_customisation()
