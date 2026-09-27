extends Node2D
class_name EverduneNPCVisual

const BODY := preload("res://assets/player_body.svg")
const HAIR := preload("res://assets/player_hair.svg")
const COAT := preload("res://assets/player_coat.svg")

var npc_data: Resource
var body_sprite: Sprite2D
var hair_sprite: Sprite2D
var coat_sprite: Sprite2D
var phase := 0.0

func setup(data: Resource) -> void:
	npc_data = data
	position = data.position
	_build_layers()
	_build_nameplate()

func _build_layers() -> void:
	body_sprite = _sprite(BODY)
	coat_sprite = _sprite(COAT)
	hair_sprite = _sprite(HAIR)
	for sprite in [body_sprite, coat_sprite, hair_sprite]:
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
	var hair := {"mara":Color("#b45f52"),"rowan":Color("#c2a36b")}.get(id,Color("#6f5947"))
	var coat := {"mara":Color("#6b5366"),"rowan":Color("#4f6958")}.get(id,Color("#52645c"))
	hair_sprite.modulate = hair
	coat_sprite.modulate = coat

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
	marker.position = Vector2(0,0)
	marker.z_index = 2
	add_child(marker)

func _process(delta: float) -> void:
	phase += delta
	var idle := sin(phase * 1.6) * 0.7
	for sprite in [body_sprite,coat_sprite,hair_sprite]:
		if sprite:
			sprite.position.y = idle
