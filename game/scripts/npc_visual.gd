extends Node2D
class_name EverduneNPCVisual

const BODY := preload("res://assets/player_body.svg")
const HAIR := preload("res://assets/player_hair.svg")
const COAT := preload("res://assets/player_coat.svg")
const ORNAMENTS := preload("res://assets/npc_ornaments.svg")

var npc_data: Resource
var state: Node
var body_sprite: Sprite2D
var hair_sprite: Sprite2D
var coat_sprite: Sprite2D
var ornament_sprite: Sprite2D
var phase := 0.0
var routine_clock := 0.0
var routine_target := Vector2.ZERO
var moving := false

func setup(data: Resource) -> void:
	npc_data = data
	position = data.position
	routine_target = position
	add_to_group("npc_visuals")
	_build_layers()
	_build_nameplate()

func set_state(value: Node) -> void:
	state = value

func _build_layers() -> void:
	body_sprite = _sprite(BODY)
	coat_sprite = _sprite(COAT)
	hair_sprite = _sprite(HAIR)
	ornament_sprite = _sprite(ORNAMENTS)
	for sprite in [body_sprite, coat_sprite, hair_sprite, ornament_sprite]:
		sprite.scale = Vector2(1.75,1.75)
		add_child(sprite)
	_apply_identity()

func _sprite(texture: Texture2D) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0,0,32,32)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return sprite

func _apply_identity() -> void:
	var id := String(npc_data.id)
	var hair := {"mara":Color("#a65c4f"),"rowan":Color("#b58f59")}.get(id,Color("#6f5947"))
	var coat := {"mara":Color("#76536a"),"rowan":Color("#4f6958")}.get(id,Color("#52645c"))
	hair_sprite.modulate = hair
	coat_sprite.modulate = coat
	ornament_sprite.visible = id == "mara"
	if id == "mara":
		ornament_sprite.modulate = Color("#d5b36d")

func _build_nameplate() -> void:
	var label := Label.new()
	label.text = String(npc_data.display_name)
	label.position = Vector2(-58,-48)
	label.size = Vector2(116,18)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size",10)
	label.add_theme_color_override("font_color",Color("#f2e4bf"))
	label.add_theme_color_override("font_shadow_color",Color(0.02,0.03,0.03,0.8))
	label.add_theme_constant_override("shadow_offset_x",1)
	label.add_theme_constant_override("shadow_offset_y",1)
	add_child(label)

	var marker := Polygon2D.new()
	marker.polygon = PackedVector2Array([Vector2(-4,-31),Vector2(0,-36),Vector2(4,-31),Vector2(0,-27)])
	marker.color = Color("#d8b86a")
	marker.position = Vector2.ZERO
	marker.z_index = 2
	add_child(marker)

func _target_for_hour(hour: int) -> Vector2:
	if String(npc_data.id) != "mara":
		return npc_data.position
	if hour < 10:
		return npc_data.morning_position
	if hour < npc_data.evening_hour:
		return npc_data.day_position
	return npc_data.evening_position

func _process(delta: float) -> void:
	phase += delta
	routine_clock += delta
	var hour := int(state.hour) if state else 10
	if routine_clock >= 2.0:
		routine_clock = 0.0
		routine_target = _target_for_hour(hour)
		moving = position.distance_to(routine_target) > 4.0

	if moving:
		position = position.move_toward(routine_target, float(npc_data.routine_speed) * delta)
		if body_sprite:
			var row := 1 if routine_target.x > position.x else 3 if routine_target.x < position.x else 0
			var frame := int(Time.get_ticks_msec() / 180) % 4
			var rect := Rect2(frame * 32, row * 32, 32, 32)
			for sprite in [body_sprite,coat_sprite,hair_sprite,ornament_sprite]:
				if sprite: sprite.region_rect = rect
	else:
		var frame := int(Time.get_ticks_msec() / 520) % 4
		var rect := Rect2(frame * 32, 0, 32, 32)
		for sprite in [body_sprite,coat_sprite,hair_sprite,ornament_sprite]:
			if sprite: sprite.region_rect = rect

	var idle := sin(phase * 1.6) * 0.7
	for sprite in [body_sprite,coat_sprite,hair_sprite,ornament_sprite]:
		if sprite:
			sprite.position.y = idle
