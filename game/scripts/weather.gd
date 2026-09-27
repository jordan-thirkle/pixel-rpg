extends Node2D
class_name EverduneWeather

const RAIN := preload("res://assets/rain_overlay.svg")
const LIGHT := preload("res://assets/light.svg")

var rain_layer: Sprite2D
var world_light: PointLight2D
var ambience: CanvasModulate
var t := 0.0
var effects_enabled := true
var lighting_enabled := true

func _ready() -> void:
	ambience = CanvasModulate.new()
	ambience.color = Color("#fff3d4")
	add_child(ambience)

	rain_layer = Sprite2D.new()
	rain_layer.texture = RAIN
	rain_layer.position = Vector2(480,270)
	rain_layer.modulate = Color(1,1,1,0)
	rain_layer.z_index = 80
	add_child(rain_layer)

	world_light = PointLight2D.new()
	world_light.texture = LIGHT
	world_light.position = Vector2(480,270)
	world_light.energy = 0.75
	world_light.texture_scale = 2.0
	world_light.z_index = 70
	add_child(world_light)

func set_weather(kind: String) -> void:
	if rain_layer:
		rain_layer.modulate.a = 0.32 if kind == "Rain" and effects_enabled else 0.0

func set_time(hour: int) -> void:
	var night := hour >= 20 or hour < 6
	if ambience:
		ambience.color = Color("#68708c") if night else (Color("#d7d5bc") if hour >= 17 else Color("#fff3d4"))
	if world_light:
		world_light.energy = 1.15 if night else 0.75

func follow_player(player: Node2D) -> void:
	if world_light:
		world_light.position = player.position

func _process(delta: float) -> void:
	t += delta
	if rain_layer:
		rain_layer.position.y = 270.0 + sin(t * 0.6) * 2.0
		rain_layer.position.x = 480.0 + sin(t * 0.35) * 3.0

func apply_settings(values: Dictionary) -> void:
	effects_enabled = bool(values.get("weather_fx", true))
	lighting_enabled = bool(values.get("dynamic_lighting", true))
	if rain_layer:
		rain_layer.visible = effects_enabled
	if world_light:
		world_light.visible = lighting_enabled
	set_weather("Rain" if rain_layer and rain_layer.modulate.a > 0.0 else "Clear")
