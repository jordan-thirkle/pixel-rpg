extends Node2D
class_name EverduneTileWorld

const TILE_SIZE := 32
const COLS := 30
const ROWS := 17
const TERRAIN := preload("res://assets/terrain_atlas.svg")
const PROPS := preload("res://assets/props.svg")
const WATER := preload("res://assets/water_anim.svg")

var water_sprites: Array[Sprite2D] = []
var ambience: Array[Node2D] = []
var layer: TileMapLayer
var water_layer: TileMapLayer
var path_layer: TileMapLayer
var anim_time := 0.0
var hearthsong_awake := false

func _ready() -> void:
	_build_tiles()
	_build_world_boundaries()
	_build_landmark_collision()
	_build_props()
	_build_atmosphere()

func _make_tileset() -> TileSet:
	var set := TileSet.new()
	set.tile_size = Vector2i(TILE_SIZE, TILE_SIZE)
	set.add_physics_layer()
	var atlas := TileSetAtlasSource.new()
	atlas.texture = TERRAIN
	atlas.texture_region_size = Vector2i(TILE_SIZE, TILE_SIZE)
	for x in range(6):
		atlas.create_tile(Vector2i(x, 0))
	set.add_source(atlas, 0)

	# Water is a real TileSet collision surface. The bridge is a separate path tile,
	# so traversal is authored by topology rather than player-side coordinate checks.
	var water_tile := atlas.get_tile_data(Vector2i(1, 0), 0)
	water_tile.set_collision_polygons_count(0, 1)
	water_tile.set_collision_polygon_points(0, 0, PackedVector2Array([
		Vector2(-16,-16), Vector2(16,-16), Vector2(16,16), Vector2(-16,16)
	]))
	return set

func _build_tiles() -> void:
	var set := _make_tileset()

	layer = TileMapLayer.new()
	layer.name = "Ground"
	layer.tile_set = set
	layer.z_index = -30
	add_child(layer)

	water_layer = TileMapLayer.new()
	water_layer.name = "River"
	water_layer.tile_set = set
	water_layer.z_index = -28
	add_child(water_layer)

	path_layer = TileMapLayer.new()
	path_layer.name = "PathsAndBridges"
	path_layer.tile_set = set
	path_layer.z_index = -26
	add_child(path_layer)

	# Base meadow: every visible square is authored by the TileMap.
	for y in range(ROWS):
		for x in range(COLS):
			layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))

	# Meadow texture variation.
	for p in [
		Vector2i(2,4), Vector2i(4,6), Vector2i(7,4), Vector2i(10,7),
		Vector2i(13,5), Vector2i(15,12), Vector2i(27,5), Vector2i(26,14),
		Vector2i(5,11), Vector2i(9,13), Vector2i(14,9), Vector2i(23,4)
	]:
		layer.set_cell(p, 0, Vector2i(4, 0))
	for p in [Vector2i(3,14),Vector2i(12,14),Vector2i(16,3),Vector2i(28,10),Vector2i(6,2)]:
		layer.set_cell(p, 0, Vector2i(5, 0))

	# River topology: water cells occupy x=19..25. TileSet physics blocks those
	# cells automatically. x=18 is the bridge bank/path corridor.
	for y in range(1, 16):
		for x in range(19, 26):
			water_layer.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

	# Curved approach from the west into Hearthfall.
	for x in range(0, 19):
		var py := 11 - int(abs(x - 8) * 0.12)
		for dy in range(-1, 2):
			if py + dy >= 0 and py + dy < ROWS:
				path_layer.set_cell(Vector2i(x, py + dy), 0, Vector2i(2, 0))

	# Bridge spans the river at the settlement crossing.
	for y in range(7, 10):
		path_layer.set_cell(Vector2i(18, y), 0, Vector2i(3, 0))

	# Secondary footpath toward the orchard and gate.
	for y in range(5, 16):
		if y % 2 == 0:
			path_layer.set_cell(Vector2i(17, y), 0, Vector2i(2, 0))
	for x in range(14, 19):
		path_layer.set_cell(Vector2i(x, 5), 0, Vector2i(2, 0))

	# Water animation follows the same authored river cells.
	for y in range(1, 16):
		for x in range(19, 26):
			var wave := Sprite2D.new()
			wave.texture = WATER
			wave.region_enabled = true
			wave.region_rect = Rect2(0, 0, 32, 32)
			wave.position = Vector2(x * TILE_SIZE + 16, y * TILE_SIZE + 16)
			wave.z_index = -27
			wave.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			wave.modulate = Color(0.82, 0.92, 0.91, 0.72)
			add_child(wave)
			water_sprites.append(wave)

func _build_world_boundaries() -> void:
	var body := StaticBody2D.new()
	body.name = "HearthfallWorldBoundary"
	body.collision_layer = 1
	body.collision_mask = 1
	add_child(body)
	for item in [
		[Vector2(480,48), Vector2(900,12)],
		[Vector2(480,492), Vector2(900,12)],
		[Vector2(48,270), Vector2(12,450)],
		[Vector2(912,270), Vector2(12,450)]
	]:
		var shape_node := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = item[1]
		shape_node.position = item[0]
		shape_node.shape = shape
		body.add_child(shape_node)

func _build_landmark_collision() -> void:
	var body := StaticBody2D.new()
	body.name = "HearthfallLandmarkCollision"
	body.collision_layer = 1
	body.collision_mask = 1
	add_child(body)
	# Building footprints and garden walls. Interactable doors/paths are intentionally
	# left open and remain controlled by their location resources.
	for item in [
		[Vector2(110,205), Vector2(112,70)],
		[Vector2(248,164), Vector2(124,74)],
		[Vector2(350,132), Vector2(92,62)],
		[Vector2(670,275), Vector2(190,30)],
		[Vector2(465,420), Vector2(112,28)],
		[Vector2(160,350), Vector2(230,12)]
	]:
		var shape_node := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = item[1]
		shape_node.position = item[0]
		shape_node.shape = shape
		body.add_child(shape_node)

func _prop(index: int, pos: Vector2, scale := Vector2.ONE, z := 0) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = PROPS
	s.region_enabled = true
	s.region_rect = Rect2(index * TILE_SIZE, 0, TILE_SIZE, TILE_SIZE)
	s.position = pos
	s.scale = scale
	s.z_index = z
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(s)
	return s

func _shadow(pos: Vector2, size := Vector2(18, 7), alpha := 0.24) -> Polygon2D:
	var p := Polygon2D.new()
	p.polygon = PackedVector2Array([
		Vector2(-size.x,0), Vector2(-size.x * 0.55,-size.y * 0.35),
		Vector2(0,-size.y * 0.5), Vector2(size.x * 0.7,-size.y * 0.25),
		Vector2(size.x,0), Vector2(size.x * 0.5,size.y * 0.45),
		Vector2(-size.x * 0.55,size.y * 0.4)
	])
	p.color = Color(0.03,0.06,0.055,alpha)
	p.position = pos
	p.z_index = -1
	add_child(p)
	return p

func _build_props() -> void:
	# Hearthfall landmarks are positioned against the authored TileMap topology.
	for p in [Vector2(360,220), Vector2(430,220)]:
		_shadow(p + Vector2(0,20), Vector2(25,8), 0.28)
		_prop(1, p, Vector2(2.2,2.2), 1)

	_shadow(Vector2(300,315), Vector2(16,6))
	_prop(2, Vector2(300,300), Vector2(1.3,1.3), 2)
	_shadow(Vector2(255,280), Vector2(15,6))
	_prop(3, Vector2(255,265), Vector2(1.5,1.5), 2)

	for p in [
		Vector2(100,100),Vector2(155,92),Vector2(205,150),Vector2(760,165),
		Vector2(860,120),Vector2(110,455),Vector2(875,450),Vector2(72,300),Vector2(890,250)
	]:
		_shadow(p + Vector2(0,12), Vector2(15,5), 0.22)
		_prop(0, p, Vector2(1.25,1.25), 2)

	_prop(4, Vector2(300,250), Vector2(1.25,1.25), 2)
	_prop(5, Vector2(620,250), Vector2(1.25,1.25), 2)
	_prop(6, Vector2(495,355), Vector2(1.15,1.15), 2)
	_prop(7, Vector2(730,370), Vector2(1.15,1.15), 2)

	for p in [Vector2(250,220),Vector2(275,205),Vector2(335,215),Vector2(350,235)]:
		_prop(9,p,Vector2.ONE,2)
	for p in [Vector2(280,285),Vector2(345,290),Vector2(395,275)]:
		_prop(2,p,Vector2.ONE,2)
	for p in [Vector2(205,315),Vector2(230,330),Vector2(270,345),Vector2(315,335),Vector2(365,345)]:
		_prop(9,p,Vector2(0.9,0.9),2)
	for p in [Vector2(120,190),Vector2(145,205),Vector2(175,215),Vector2(825,190),Vector2(855,210)]:
		_prop(0,p,Vector2.ONE,2)
	_prop(3,Vector2(565,300),Vector2(1.1,1.1),2)
	_prop(2,Vector2(545,320),Vector2(1.05,1.05),2)
	_prop(3,Vector2(665,305),Vector2(1.1,1.1),2)
	_prop(9,Vector2(685,325),Vector2.ONE,2)
	var gate := Sprite2D.new()
	gate.texture = load("res://assets/sleeping_gate.svg") as Texture2D
	gate.position = Vector2(820,430)
	gate.scale = Vector2(1.0,1.0)
	gate.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	gate.z_index = 4
	add_child(gate)

func _build_atmosphere() -> void:
	for p in [
		Vector2(170,130),Vector2(230,175),Vector2(315,185),Vector2(405,300),
		Vector2(520,180),Vector2(590,340),Vector2(700,125),Vector2(820,285)
	]:
		var glow := Polygon2D.new()
		glow.polygon = PackedVector2Array([
			Vector2(-3,-1),Vector2(-1,-3),Vector2(1,-3),Vector2(3,-1),
			Vector2(3,1),Vector2(1,3),Vector2(-1,3),Vector2(-3,1)
		])
		glow.color = Color(0.93,0.80,0.47,0.0)
		glow.position = p
		glow.z_index = 6
		add_child(glow)
		ambience.append(glow)

func awaken_echo(id: String) -> void:
	if id != "old_road" or hearthsong_awake:
		return
	hearthsong_awake = true
	# The first Echo changes the world presentation rather than only awarding XP.
	for glow in ambience:
		var polygon := glow as Polygon2D
		polygon.color = Color("#e8c77c")
	for p in [Vector2(470,335),Vector2(500,320),Vector2(530,305),Vector2(560,290)]:
		var marker := Polygon2D.new()
		marker.polygon = PackedVector2Array([
			Vector2(0,-6),Vector2(4,0),Vector2(0,6),Vector2(-4,0)
		])
		marker.position = p
		marker.z_index = 7
		marker.color = Color("#e8c77c")
		add_child(marker)
		var tween := create_tween().set_loops()
		tween.tween_property(marker,"modulate:a",0.15,0.8)
		tween.tween_property(marker,"modulate:a",1.0,0.8)

func place_hearth_lamp() -> void:
	var lamp := Sprite2D.new()
	lamp.texture = load("res://assets/environment_fx.svg") as Texture2D
	lamp.region_enabled = true
	lamp.region_rect = Rect2(64,0,32,32)
	lamp.position = Vector2(335,275)
	lamp.scale = Vector2(1.15,1.15)
	lamp.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	lamp.z_index = 8
	add_child(lamp)
	var glow := Polygon2D.new()
	glow.polygon = PackedVector2Array([
		Vector2(-8,0),Vector2(-5,-5),Vector2(0,-8),Vector2(5,-5),
		Vector2(8,0),Vector2(5,5),Vector2(0,8),Vector2(-5,5)
	])
	glow.position = Vector2(335,260)
	glow.color = Color("#e8c77c")
	glow.z_index = 7
	add_child(glow)
	var tween := create_tween().set_loops()
	tween.tween_property(glow,"modulate:a",0.25,0.8)
	tween.tween_property(glow,"modulate:a",0.75,0.8)

func set_water_animation(enabled: bool) -> void:
	for wave in water_sprites:
		wave.visible = enabled

func _process(delta: float) -> void:
	anim_time += delta
	var frame := int(anim_time * 3.0) % 4
	for wave in water_sprites:
		wave.region_rect = Rect2(frame * TILE_SIZE, 0, TILE_SIZE, TILE_SIZE)
	for i in range(ambience.size()):
		var glow := ambience[i] as Polygon2D
		var pulse := (sin(anim_time * 1.8 + float(i) * 1.37) + 1.0) * 0.5
		glow.modulate.a = 0.16 + pulse * 0.34
		glow.position.y += sin(anim_time * 0.7 + float(i)) * delta * 0.6
