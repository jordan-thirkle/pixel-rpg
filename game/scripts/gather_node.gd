extends Area2D
class_name EverduneGatherNode

signal harvested(node)

@export var resource_id := "wood"
@export var amount := 1
@export var respawn_seconds := 18.0
var available := true
var respawn_left := 0.0
var visual: Sprite2D

func setup(id: String, texture: Texture2D, atlas_index: int, at: Vector2) -> void:
	resource_id = id
	position = at
	visual = Sprite2D.new()
	visual.texture = texture
	visual.region_enabled = true
	visual.region_rect = Rect2(atlas_index * 32, 0, 32, 32)
	visual.scale = Vector2(1.1,1.1)
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual)
	add_to_group("gather_nodes")

func can_gather() -> bool:
	return available

func gather() -> bool:
	if not available:
		return false
	available = false
	if visual: visual.visible = false
	respawn_left = respawn_seconds
	harvested.emit(self)
	return true

func _process(delta: float) -> void:
	if not available:
		respawn_left -= delta
		if respawn_left <= 0.0:
			available = true
			if visual: visual.visible = true
