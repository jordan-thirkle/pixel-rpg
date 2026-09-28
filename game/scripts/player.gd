extends CharacterBody2D
class_name EverdunePlayer

const BODY := preload("res://assets/player_body.svg")
const HAIR := preload("res://assets/player_hair.svg")
const COAT := preload("res://assets/player_coat.svg")
const FACE := preload("res://assets/hero_face.svg")
const SHIRT := preload("res://assets/hero_shirt.svg")
const TROUSERS := preload("res://assets/hero_trousers.svg")
const BOOTS := preload("res://assets/hero_boots.svg")
const ACCESSORY := preload("res://assets/hero_accessory.svg")
const BACK := preload("res://assets/hero_back.svg")
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
var face_sprite: Sprite2D
var shirt_sprite: Sprite2D
var trousers_sprite: Sprite2D
var boots_sprite: Sprite2D
var accessory_sprite: Sprite2D
var back_sprite: Sprite2D
var equipment := "axe"
var step_phase := 0.0
var last_moving := false
var camera: Camera2D
var runtime_sprite: Sprite2D

const CHARACTER_SCALE := Vector2(2.0, 2.0)

func _ready() -> void:
	z_index = 20
	_build_layers()
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 9.0
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 960
	camera.limit_bottom = 540
	add_child(camera)
	queue_redraw()

func _build_layers() -> void:
	back_sprite = _atlas_sprite(BACK)
	boots_sprite = _atlas_sprite(BOOTS)
	trousers_sprite = _atlas_sprite(TROUSERS)
	shirt_sprite = _atlas_sprite(SHIRT)
	body_sprite = _atlas_sprite(BODY)
	face_sprite = _atlas_sprite(FACE)
	coat_sprite = _atlas_sprite(COAT)
	hair_sprite = _atlas_sprite(HAIR)
	accessory_sprite = _atlas_sprite(ACCESSORY)
	tool_sprite = _atlas_sprite(TOOLS)
	tool_sprite.visible = false
	for sprite in [back_sprite, boots_sprite, trousers_sprite, shirt_sprite, body_sprite, face_sprite, coat_sprite, hair_sprite, accessory_sprite, tool_sprite]:
		add_child(sprite)
	_apply_customisation()
	runtime_sprite = Sprite2D.new()
	runtime_sprite.texture = preload("res://assets/everdune/wayfarer_sheet.svg")
	runtime_sprite.region_enabled = true
	runtime_sprite.region_rect = Rect2(0,0,32,32)
	runtime_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	runtime_sprite.scale = CHARACTER_SCALE
	runtime_sprite.z_index = 2
	add_child(runtime_sprite)
	for sprite in [back_sprite, boots_sprite, trousers_sprite, shirt_sprite, body_sprite, face_sprite, coat_sprite, hair_sprite, accessory_sprite]:
		sprite.visible = false

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
	if runtime_sprite: runtime_sprite.region_rect = rect
	if hair_sprite: hair_sprite.region_rect = rect
	if coat_sprite: coat_sprite.region_rect = rect
	if tool_sprite:
		tool_sprite.region_rect = rect
		tool_sprite.visible = action_time > 0.0
		tool_sprite.modulate = Color("#d9c48a") if equipment == "axe" else Color("#a9c3c6")

	# Tiny grounded motion makes movement feel less mechanically flat.
	var stride := sin(step_phase) * (0.8 if moving else 0.0)
	for sprite in [back_sprite, boots_sprite, trousers_sprite, shirt_sprite, body_sprite, face_sprite, coat_sprite, hair_sprite, accessory_sprite]:
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

func _apply_customisation() -> void:
	if state == null:
		return
	var hair := String(state.character.get("hair", "dark"))
	var coat := String(state.character.get("coat", "teal"))
	var hair_colors := {"dark":Color("#4b3730"),"ember":Color("#7d4938"),"gold":Color("#9a713e")}
	var coat_colors := {"teal":Color("#355f59"),"wine":Color("#704f65"),"ochre":Color("#80633b")}
	if hair_sprite: hair_sprite.modulate = hair_colors.get(hair, Color.WHITE)
	if coat_sprite: coat_sprite.modulate = coat_colors.get(coat, Color.WHITE)
	if accessory_sprite: accessory_sprite.modulate = Color("#d9b66f") if coat == "teal" else Color("#d2a36a")
	if shirt_sprite: shirt_sprite.modulate = Color("#d0b28a")
	if trousers_sprite: trousers_sprite.modulate = Color("#4b5660")
	if boots_sprite: boots_sprite.modulate = Color("#3e3029")
	if back_sprite: back_sprite.modulate = Color("#674b3b")

func refresh_customisation() -> void:
	_apply_customisation()
	if runtime_sprite:
		runtime_sprite.modulate = {"teal":Color.WHITE,"wine":Color("#ead2df"),"ochre":Color("#ead39a")}.get(String(state.character.get("coat","teal")),Color.WHITE)
