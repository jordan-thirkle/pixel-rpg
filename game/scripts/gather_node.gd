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
var glow_ring: Polygon2D

func setup(id: String, texture: Texture2D, atlas_index: int, at: Vector2, skill := "gathering", xp := 10) -> void:
	resource_id = id
	skill_id = skill
	skill_xp = xp
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
	glow_ring = Polygon2D.new()
	glow_ring.name = "InteractionGlow"
	glow_ring.polygon = PackedVector2Array([
		Vector2(-7,0),Vector2(-5,-2),Vector2(0,-3),Vector2(5,-2),
		Vector2(7,0),Vector2(5,2),Vector2(0,3),Vector2(-5,2)
	])
	glow_ring.color = Color("#d7b86d")
	glow_ring.position = Vector2(0,13)
	glow_ring.modulate.a = 0.18
	add_child(glow_ring)
	var tween := create_tween().set_loops()
	tween.tween_property(glow_ring,"modulate:a",0.08,0.9)
	tween.tween_property(glow_ring,"modulate:a",0.24,0.9)

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

func show_mastery_feedback(message: String) -> void:
	# A tiny local response keeps mastery attached to the thing the player touched.
	if visual:
		var pulse := create_tween()
		pulse.tween_property(visual,"scale",base_scale * 1.16,0.09)
		pulse.tween_property(visual,"scale",base_scale,0.18)
	if glow_ring:
		var flash := create_tween()
		glow_ring.modulate = Color(1.0,0.9,0.65,0.65)
		flash.tween_property(glow_ring,"modulate:a",0.12,0.38)

	# Store the text for the presentation layer without introducing a second UI authority.
	set_meta("mastery_feedback", message)

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
