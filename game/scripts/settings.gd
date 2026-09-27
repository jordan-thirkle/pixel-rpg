extends Node
class_name EverduneSettings

const PATH := "user://everdune_settings.cfg"

var values := {
	"fullscreen": false,
	"vsync": true,
	"weather_fx": true,
	"dynamic_lighting": true,
	"particles": true,
	"animated_water": true,
	"screen_shake": true,
	"screen_flash": true,
	"integer_scaling": true,
	"ui_scale": 1.0,
	"master_volume": 1.0,
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"text_speed": 1.0,
	"high_contrast": false
}

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(PATH) != OK:
		return
	for key in values.keys():
		if config.has_section_key("settings", key):
			values[key] = config.get_value("settings", key)

func save_settings() -> void:
	var config := ConfigFile.new()
	for key in values.keys():
		config.set_value("settings", key, values[key])
	config.save(PATH)

func set_value(key: String, value) -> void:
	if not values.has(key):
		return
	values[key] = value
	save_settings()

func get_value(key: String, fallback = null):
	return values.get(key, fallback)
