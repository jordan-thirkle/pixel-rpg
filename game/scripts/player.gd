extends CharacterBody2D
class_name EverdunePlayer

const BODY := preload("res://assets/player_body.svg")
const HAIR := preload("res://assets/player_hair.svg")
const COAT := preload("res://assets/player_coat.svg")
const TOOLS := preload("res://assets/hero_tools.svg")

var state: Node
var speed := 145.0
var facing := Vector2.DOWN
var bob := 0.0
var body_sprite: Sprite2D
var hair_sprite: Sprite2D
var coat_sprite: Sprite2D
var animated := true
var action_time := 0.0
var action_kind := ""
var tool_sprite: Sprite2D
var equipment := "axe"

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
	body_sprite.position = Vector2(0,0)
	hair_sprite.position = Vector2(0,0)
	coat_sprite.position = Vector2(0,0)
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
	return s

func _process(delta: float) -> void:
	bob += delta * (9.0 if velocity.length() > 1.0 else 2.0)
	action_time = maxf(0.0, action_time - delta)
	var moving := velocity.length() > 1.0
	var frame := int(floor(fmod(bob * (0.9 if moving else 0.35), 4.0)))
	var row := _direction_row()
	var rect := Rect2(frame * 32, row * 32, 32, 32)
	if body_sprite: body_sprite.region_rect = rect
	if hair_sprite: hair_sprite.region_rect = rect
	if coat_sprite: coat_sprite.region_rect = rect
	if tool_sprite:
		tool_sprite.region_rect = Rect2(frame * 32, row * 32, 32, 32)
		tool_sprite.visible = action_time > 0.0
		tool_sprite.modulate = Color("#d9c48a") if equipment == "axe" else Color("#a9c3c6")

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
		velocity = input_vector * speed
		facing = input_vector
		if state:
			state.energy = maxf(0.0, state.energy - delta * 0.7)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 8.0 * delta)
	var previous_position := position
	move_and_slide()
	var in_river := position.x > 600.0 and position.x < 850.0 and position.y > 60.0 and position.y < 490.0
	var on_bridge := position.x > 575.0 and position.x < 610.0 and position.y > 224.0 and position.y < 320.0
	if in_river and not on_bridge:
		position = previous_position
		velocity = Vector2.ZERO
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
