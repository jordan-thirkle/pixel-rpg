extends Node2D
class_name EverduneTileWorld

const TILE_SIZE := 32
const COLS := 30
const ROWS := 17
const TERRAIN := preload("res://assets/terrain_atlas.svg")
const PROPS := preload("res://assets/props.svg")

var layer: TileMapLayer

func _ready() -> void:
	_build_tiles()
	_build_props()

func _build_tiles() -> void:
	var set := TileSet.new()
	set.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	var atlas := TileSetAtlasSource.new()
	atlas.texture = TERRAIN
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	for x in range(3):
		atlas.create_tile(Vector2i(x, 0))
	set.add_source(atlas, 0)
	layer = TileMapLayer.new()
	layer.name = "Terrain"
	layer.tile_set = set
	layer.z_index = -10
	add_child(layer)
	for y in range(ROWS):
		for x in range(COLS):
			layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
	for y in range(2, 16):
		for x in range(19, 26):
			layer.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
	# Flower meadow around the settlement makes the valley feel authored rather than tiled.
	for p in [Vector2i(2,4),Vector2i(4,6),Vector2i(7,4),Vector2i(10,7),Vector2i(13,5),Vector2i(15,12),Vector2i(27,5),Vector2i(26,14)]:
		layer.set_cell(p, 0, Vector2i(4, 0))
	for p in [Vector2i(3,14),Vector2i(12,14),Vector2i(16,3),Vector2i(28,10)]:
		layer.set_cell(p, 0, Vector2i(5, 0))
	for x in range(0, 19):
		var py := 11 - int(abs(x - 8) * 0.12)
		for dy in range(-1, 2):
			if py + dy >= 0 and py + dy < ROWS:
				layer.set_cell(Vector2i(x, py + dy), 0, Vector2i(2, 0))
	for y in range(7, 10):
		layer.set_cell(Vector2i(18, y), 0, Vector2i(2, 0))

func _prop(index: int, pos: Vector2, scale := Vector2.ONE) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = PROPS
	s.region_enabled = true
	s.region_rect = Rect2(index * TILE_SIZE, 0, TILE_SIZE, TILE_SIZE)
	s.position = pos
	s.scale = scale
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(s)
	return s

func _build_props() -> void:
	# Hearthfall landmark cluster.
	_prop(1, Vector2(360, 220), Vector2(2.2, 2.2))
	_prop(1, Vector2(430, 220), Vector2(2.2, 2.2))
	_prop(2, Vector2(300, 300), Vector2(1.3, 1.3))
	_prop(3, Vector2(255, 265), Vector2(1.5, 1.5))
	for p in [Vector2(100,100),Vector2(155,92),Vector2(205,150),Vector2(760,165),Vector2(860,120),Vector2(110,455),Vector2(875,450),Vector2(72,300),Vector2(890,250)]:
		_prop(0, p, Vector2(1.25, 1.25))
	_prop(4, Vector2(300,250), Vector2(1.25,1.25))
	_prop(5, Vector2(620,250), Vector2(1.25,1.25))
	_prop(6, Vector2(495,355), Vector2(1.15,1.15))
	_prop(7, Vector2(730,370), Vector2(1.15,1.15))


func _process(_delta: float) -> void:
	# Gentle water shimmer: only the atlas cell changes, keeping presentation data-driven.
	if layer == null:
		return
	var phase := int(Time.get_ticks_msec() / 900) % 2
	var water_tile := Vector2i(1 + phase, 0) if false else Vector2i(1, 0)
	# Kept intentionally deterministic; future authored animated water can replace this hook.
