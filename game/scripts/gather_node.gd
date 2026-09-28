extends Area2D
class_name EverduneGatherNode

signal harvested(node)

@export var resource_id := "wood"
@export var amount := 1
@export var respawn_seconds := 18.0
var available := true
var respawn_left := 0.0
var visual: Sprite2D
var base_scale := Vector2(1.1,1.1)
var skill_id := "gathering"
var skill_xp := 10
var bonus_resource_id := ""
var bonus_chance := 0.0

func setup(id: String, texture: Texture2D, atlas_index: int, at: Vector2, skill := "gathering", xp := 10, bonus_id := "", bonus_roll := 0.0) -> void:
	resource_id = id
	skill_id = skill
	skill_xp = xp
	bonus_resource_id = bonus_id
	bonus_chance = bonus_roll
	position = at
	visual = Sprite2D.new()
	visual.texture = texture
	visual.region_enabled = true
	visual.region_rect = Rect2(atlas_index * 32, 0, 32, 32)
	visual.scale = base_scale
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual)
	add_to_group("gather_nodes")
	_build_prompt_ring()

func _build_prompt_ring() -> void:
	var ring := Polygon2D.new()
	ring.name = "InteractionGlow"
	ring.polygon = PackedVector2Array([
		Vector2(-7,0),Vector2(-5,-2),Vector2(0,-3),Vector2(5,-2),
		Vector2(7,0),Vector2(5,2),Vector2(0,3),Vector2(-5,2)
	])
	ring.color = Color("#d7b86d")
	ring.position = Vector2(0,13)
	ring.modulate.a = 0.18
	add_child(ring)
	var tween := create_tween().set_loops()
	tween.tween_property(ring,"modulate:a",0.08,0.9)
	tween.tween_property(ring,"modulate:a",0.24,0.9)

func can_gather() -> bool:
	return available

func gather() -> bool:
	if not available:
		return false
	available = false
	respawn_left = respawn_seconds
	if visual:
		var tween := create_tween()
		tween.tween_property(visual,"scale",base_scale * 1.28,0.08)
		tween.tween_property(visual,"scale",base_scale * 0.72,0.14)
		tween.tween_callback(func(): visual.visible = false)
	harvested.emit(self)
	return true

func _process(delta: float) -> void:
	if not available:
		respawn_left -= delta
		if respawn_left <= 0.0:
			available = true
			if visual:
				visual.visible = true
				visual.scale = base_scale * 0.72
				var tween := create_tween()
				tween.tween_property(visual,"scale",base_scale * 1.12,0.16)
				tween.tween_property(visual,"scale",base_scale,0.24)
