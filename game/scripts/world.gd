extends Node2D
class_name EverduneWorld

var river_rect := Rect2(600, 60, 250, 430)
var road_points := PackedVector2Array([Vector2(80,415),Vector2(190,380),Vector2(310,360),Vector2(455,350),Vector2(570,345),Vector2(690,335),Vector2(860,300)])

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0,0,960,540), Color("#2f5847"))
	draw_rect(Rect2(0,0,960,540), Color("#416b50"), false, 4)
	for p in [Vector2(70,85),Vector2(150,75),Vector2(850,85),Vector2(900,150),Vector2(110,470),Vector2(860,455)]:
		_draw_tree_cluster(p)
	draw_rect(river_rect, Color("#284e5a"))
	draw_rect(Rect2(614,60,222,430), Color("#3b7180"))
	for y in range(78,475,34):
		draw_line(Vector2(630,y),Vector2(810,y-5),Color("#78a7a2"),2)
	draw_rect(Rect2(575,248,74,62),Color("#5a3d2d"))
	for x in range(581,647,12):
		draw_rect(Rect2(x,252,8,54),Color("#9a6b47"))
	draw_line(Vector2(575,255),Vector2(649,255),Color("#c18b5b"),4)
	draw_circle(Vector2(300,250),120,Color("#557052"))
	draw_circle(Vector2(300,250),94,Color("#627a56"))
	_draw_house(Vector2(360,220),"Hearthfall")
	_draw_house(Vector2(430,220),"Home")
	_draw_market(Vector2(255,265))
	_draw_well(Vector2(300,300))
	var previous := road_points[0]
	for point in road_points:
		draw_line(previous,point,Color("#9b825d"),22)
		draw_line(previous,point,Color("#b49a6e"),16)
		previous = point
	for x in range(110,520,42):
		for y in range(105,180,30):
			draw_rect(Rect2(x,y,18,13),Color("#6d824f"))
			draw_circle(Vector2(x+9,y+5),3,Color("#d9b15d"))
	_draw_tree(Vector2(205,150))
	_draw_tree(Vector2(760,165))
	_draw_rock(Vector2(180,360))
	_draw_rock(Vector2(820,330))
	draw_circle(Vector2(495,355),22,Color("#46535c"))
	draw_circle(Vector2(495,355),16,Color("#6e7777"))
	draw_arc(Vector2(495,355),25,0,TAU,32,Color("#c7b98b"),2)
	draw_line(Vector2(485,355),Vector2(505,355),Color("#e0c982"),2)
	for p in [Vector2(125,220),Vector2(160,270),Vector2(210,235),Vector2(520,180),Vector2(540,210),Vector2(115,330),Vector2(350,390),Vector2(470,410)]:
		_draw_flower(p)

func _draw_house(pos:Vector2,label:String)->void:
	draw_rect(Rect2(pos-Vector2(28,20),Vector2(56,40)),Color("#9c7250"))
	draw_colored_polygon(PackedVector2Array([pos+Vector2(-34,-20),pos+Vector2(0,-48),pos+Vector2(34,-20)]),Color("#684b3c"))
	draw_rect(Rect2(pos+Vector2(-8,0),Vector2(16,20)),Color("#49362f"))
	draw_rect(Rect2(pos+Vector2(12,-8),Vector2(10,10)),Color("#d9c17d"))
	if label=="Home": draw_circle(pos+Vector2(0,-54),5,Color("#e8c66a"))

func _draw_market(pos:Vector2)->void:
	draw_rect(Rect2(pos-Vector2(38,20),Vector2(76,40)),Color("#7b5b43"))
	draw_colored_polygon(PackedVector2Array([pos+Vector2(-43,-20),pos+Vector2(0,-43),pos+Vector2(43,-20)]),Color("#a96f4d"))
	draw_rect(Rect2(pos+Vector2(-30,-3),Vector2(60,5)),Color("#d1ad67"))

func _draw_well(pos:Vector2)->void:
	draw_circle(pos,19,Color("#5b5d58"))
	draw_circle(pos,13,Color("#273d42"))
	draw_rect(Rect2(pos+Vector2(-25,-32),Vector2(50,5)),Color("#6d4934"))
	draw_line(pos+Vector2(-18,-28),pos+Vector2(-18,-8),Color("#6d4934"),5)
	draw_line(pos+Vector2(18,-28),pos+Vector2(18,-8),Color("#6d4934"),5)

func _draw_tree(pos:Vector2)->void:
	draw_rect(Rect2(pos.x-5,pos.y+8,10,20),Color("#664832"))
	draw_circle(pos+Vector2(-10,0),16,Color("#315a43"))
	draw_circle(pos+Vector2(8,-5),19,Color("#3d6b4a"))
	draw_circle(pos+Vector2(0,-15),15,Color("#527a4d"))

func _draw_tree_cluster(pos:Vector2)->void:
	for offset in [Vector2(-24,10),Vector2(0,-8),Vector2(25,8)]: _draw_tree(pos+offset)

func _draw_rock(pos:Vector2)->void:
	draw_colored_polygon(PackedVector2Array([pos+Vector2(-18,8),pos+Vector2(-10,-12),pos+Vector2(7,-18),pos+Vector2(20,2),pos+Vector2(10,15),pos+Vector2(-10,15)]),Color("#66736c"))
	draw_line(pos+Vector2(-7,-8),pos+Vector2(7,2),Color("#8b978d"),2)

func _draw_flower(pos:Vector2)->void:
	draw_line(pos,pos+Vector2(0,8),Color("#8eac5d"),2)
	draw_circle(pos,3,Color("#e3c36c"))
	for a in [0.0,1.57,3.14,4.71]: draw_circle(pos+Vector2(cos(a),sin(a))*4,2.5,Color("#d08a74"))
