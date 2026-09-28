extends CanvasLayer
class_name EverduneUI

const SCENE_ART := preload("res://assets/hearthfall_scene.svg")
const PREVIEW_BODY := preload("res://assets/player_body.svg")
const PREVIEW_HAIR := preload("res://assets/player_hair.svg")
const PREVIEW_COAT := preload("res://assets/player_coat.svg")
const PREVIEW_FACE := preload("res://assets/hero_face.svg")
const PREVIEW_SHIRT := preload("res://assets/hero_shirt.svg")
const PREVIEW_TROUSERS := preload("res://assets/hero_trousers.svg")
const PREVIEW_BOOTS := preload("res://assets/hero_boots.svg")
const PREVIEW_ACCESSORY := preload("res://assets/hero_accessory.svg")
const PREVIEW_BACK := preload("res://assets/hero_back.svg")

signal creation_finished
signal start_requested(continue_game: bool)
signal sound_requested(kind: String)
signal settings_changed(values: Dictionary)
signal craft_requested

var state: Node
var prompt_label: Label
var toast_label: Label
var stats_label: Label
var quest_label: Label
var dialog_panel: Panel
var dialog_title: Label
var dialog_text: Label
var inventory_panel: Panel
var inventory_text: Label
var craft_button: Button
var creation_panel: Panel
var name_edit: LineEdit
var hair_label: Label
var coat_label: Label
var selected_hair := "dark"
var selected_coat := "teal"
var panel_style: StyleBoxFlat
var button_style: StyleBoxFlat
var settings_panel: Panel
var settings_values := {}
var start_menu: Panel
var continue_button: Button
var session_active := false
var quest_visible := true
var settings_from_start := false
var hud_settings_button: Button
var preview_body: Sprite2D
var preview_hair: Sprite2D
var preview_coat: Sprite2D
var preview_face: Sprite2D
var preview_shirt: Sprite2D
var preview_trousers: Sprite2D
var preview_boots: Sprite2D
var preview_accessory: Sprite2D
var preview_back: Sprite2D
var start_backdrop: TextureRect
var start_overlay: ColorRect

func _ready() -> void:
	layer = 100
	_build_ui()

func _label(text: String, pos: Vector2, size := 16) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", Color("#f3ead2"))
	add_child(l)
	return l

func _build_ui() -> void:
	panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("#272b2a", 0.94)
	panel_style.border_color = Color("#9b845f", 0.8)
	panel_style.set_border_width_all(2)
	panel_style.corner_radius_top_left = 6
	panel_style.corner_radius_top_right = 6
	panel_style.corner_radius_bottom_left = 6
	panel_style.corner_radius_bottom_right = 6
	button_style = StyleBoxFlat.new()
	button_style.bg_color = Color("#3e5148")
	button_style.border_color = Color("#bda56e")
	button_style.set_border_width_all(1)
	button_style.corner_radius_top_left = 4
	button_style.corner_radius_top_right = 4
	button_style.corner_radius_bottom_left = 4
	button_style.corner_radius_bottom_right = 4
	prompt_label = _label("", Vector2(28,492), 14)
	prompt_label.add_theme_color_override("font_color", Color("#f4e8c5"))
	toast_label = _label("", Vector2(28,452), 16)
	toast_label.add_theme_color_override("font_color", Color("#f0c96a"))
	stats_label = _label("", Vector2(28,22), 16)
	quest_label = _label("", Vector2(710,24), 14)
	hud_settings_button = Button.new()
	hud_settings_button.text = "Settings"
	hud_settings_button.position = Vector2(585,20)
	hud_settings_button.size = Vector2(105,32)
	hud_settings_button.add_theme_stylebox_override("normal", button_style)
	hud_settings_button.pressed.connect(toggle_settings)
	add_child(hud_settings_button)
	quest_label.add_theme_color_override("font_color", Color("#f1dfb2"))

	dialog_panel = Panel.new()
	dialog_panel.add_theme_stylebox_override("panel", panel_style)
	dialog_panel.position = Vector2(150,365)
	dialog_panel.size = Vector2(660,120)
	dialog_panel.visible = false
	add_child(dialog_panel)
	dialog_title = Label.new()
	dialog_title.position = Vector2(20,12)
	dialog_title.add_theme_font_size_override("font_size",20)
	dialog_title.add_theme_color_override("font_color",Color("#e7c77b"))
	dialog_panel.add_child(dialog_title)
	dialog_text = Label.new()
	dialog_text.position = Vector2(20,46)
	dialog_text.size = Vector2(620,60)
	dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialog_text.add_theme_font_size_override("font_size",16)
	dialog_text.add_theme_color_override("font_color",Color("#f3ead2"))
	dialog_panel.add_child(dialog_text)

	inventory_panel = Panel.new()
	inventory_panel.add_theme_stylebox_override("panel", panel_style)
	inventory_panel.position = Vector2(250,105)
	inventory_panel.size = Vector2(460,320)
	inventory_panel.visible = false
	add_child(inventory_panel)
	inventory_text = Label.new()
	inventory_text.position = Vector2(28,24)
	inventory_text.size = Vector2(404,235)
	inventory_text.add_theme_font_size_override("font_size",17)
	inventory_text.add_theme_color_override("font_color",Color("#f3ead2"))
	inventory_panel.add_child(inventory_text)
	craft_button = Button.new()
	craft_button.add_theme_stylebox_override("normal", button_style)
	craft_button.text = "Craft Hearth Lamp"
	craft_button.position = Vector2(28,248)
	craft_button.size = Vector2(190,36)
	craft_button.pressed.connect(_craft_lamp)
	inventory_panel.add_child(craft_button)

	_build_start_menu()
	_build_character_creator()
	_build_settings_panel()

func _start_label(text:String,pos:Vector2,size:int)->Label:
	var l:=Label.new()
	l.text=text
	l.position=pos
	l.add_theme_font_size_override("font_size",size)
	l.add_theme_color_override("font_color",Color("#f3ead2"))
	start_menu.add_child(l)
	return l

func _build_start_menu() -> void:
	start_menu = Panel.new()
	var transparent := StyleBoxFlat.new()
	transparent.bg_color = Color(0,0,0,0)
	start_menu.add_theme_stylebox_override("panel", transparent)
	start_menu.position = Vector2.ZERO
	start_menu.size = Vector2(960,540)
	add_child(start_menu)

	start_backdrop = TextureRect.new()
	start_backdrop.texture = SCENE_ART
	start_backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	start_backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	start_backdrop.position = Vector2.ZERO
	start_backdrop.size = Vector2(960,540)
	start_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	start_backdrop.visible = false
	start_menu.add_child(start_backdrop)

	start_overlay = ColorRect.new()
	start_overlay.color = Color(0.015,0.028,0.025,0.34)
	start_overlay.position = Vector2.ZERO
	start_overlay.size = Vector2(960,540)
	start_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	start_menu.add_child(start_overlay)

	var identity := _start_label("EVERDUNE", Vector2(54,48), 52)
	identity.add_theme_color_override("font_color", Color("#f4e7c5"))
	var identity_shadow := _start_label("EVERDUNE", Vector2(56,50), 52)
	identity_shadow.add_theme_color_override("font_color", Color(0.03,0.07,0.06,0.55))
	start_menu.move_child(identity_shadow, start_menu.get_child_count() - 1)
	start_menu.move_child(identity, start_menu.get_child_count() - 1)
	var subtitle := _start_label("THE WORLD REMEMBERS", Vector2(58,108), 15)
	subtitle.add_theme_color_override("font_color", Color("#d8bd78"))
	var rule := ColorRect.new()
	rule.color = Color("#b58d50")
	rule.position = Vector2(58,137)
	rule.size = Vector2(230,2)
	start_menu.add_child(rule)
	var premise := _start_label("A quiet fantasy RPG about\nexploration, memory and home.", Vector2(58,158), 18)
	premise.size = Vector2(330,62)
	premise.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	premise.add_theme_color_override("font_color", Color("#f0e7d4"))

	var card := Panel.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("#18211d",0.91)
	card_style.border_color = Color("#b89a62",0.82)
	card_style.set_border_width_all(1)
	card_style.corner_radius_top_left = 8
	card_style.corner_radius_top_right = 8
	card_style.corner_radius_bottom_left = 8
	card_style.corner_radius_bottom_right = 8
	card_style.shadow_color = Color(0,0,0,0.38)
	card_style.shadow_size = 14
	card.add_theme_stylebox_override("panel", card_style)
	card.position = Vector2(555,82)
	card.size = Vector2(350,340)
	start_menu.add_child(card)

	var card_title := Label.new()
	card_title.text = "BEGIN YOUR JOURNEY"
	card_title.position = Vector2(30,24)
	card_title.add_theme_font_size_override("font_size",18)
	card_title.add_theme_color_override("font_color",Color("#e7c77b"))
	card.add_child(card_title)

	var card_note := Label.new()
	card_note.text = "Step into Larkmere Valley.\nYour first memory is waiting."
	card_note.position = Vector2(30,55)
	card_note.size = Vector2(285,52)
	card_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_note.add_theme_font_size_override("font_size",13)
	card_note.add_theme_color_override("font_color",Color("#c9c0ad"))
	card.add_child(card_note)

	var new_game := Button.new()
	new_game.text = "NEW JOURNEY"
	new_game.position = Vector2(30,122)
	new_game.size = Vector2(290,52)
	new_game.add_theme_stylebox_override("normal", button_style)
	new_game.add_theme_stylebox_override("hover", button_style)
	new_game.pressed.connect(func(): _open_creator())
	card.add_child(new_game)

	continue_button = Button.new()
	continue_button.text = "CONTINUE"
	continue_button.position = Vector2(30,184)
	continue_button.size = Vector2(290,46)
	continue_button.add_theme_stylebox_override("normal", button_style)
	continue_button.add_theme_stylebox_override("hover", button_style)
	continue_button.pressed.connect(func(): start_requested.emit(true))
	card.add_child(continue_button)

	var settings_button := Button.new()
	settings_button.text = "SETTINGS"
	settings_button.position = Vector2(30,240)
	settings_button.size = Vector2(140,40)
	settings_button.add_theme_stylebox_override("normal", button_style)
	settings_button.pressed.connect(toggle_settings)
	card.add_child(settings_button)

	var footer := Label.new()
	footer.text = "WASD / Arrows   •   E interact   •   I inventory"
	footer.position = Vector2(30,295)
	footer.add_theme_font_size_override("font_size",11)
	footer.add_theme_color_override("font_color",Color("#8e927f"))
	card.add_child(footer)

	var build := _start_label("GODOT 4.7.2  •  SINGLE-PLAYER  •  BUILD FOUNDATION", Vector2(58,494), 10)
	build.add_theme_color_override("font_color", Color("#a9a28f"))

func set_save_available(available: bool) -> void:
	if continue_button:
		continue_button.disabled = not available
		continue_button.modulate = Color.WHITE if available else Color("#66645f")

func _open_creator() -> void:
	start_menu.visible = false
	creation_panel.visible = true
	session_active = false

func begin_session() -> void:
	session_active = true
	quest_visible = true
	start_menu.visible = false
	creation_panel.visible = false

func _build_character_creator() -> void:
	creation_panel = Panel.new()
	creation_panel.add_theme_stylebox_override("panel", panel_style)
	creation_panel.position = Vector2(220,92)
	creation_panel.size = Vector2(520,360)
	add_child(creation_panel)
	_label_to_panel("YOUR WAYFARER", Vector2(28,22), 24)
	_label_to_panel("Choose a name and a simple visual identity.", Vector2(28,58), 14)
	name_edit = LineEdit.new()
	name_edit.placeholder_text = "Wayfarer name"
	name_edit.position = Vector2(28,92)
	name_edit.size = Vector2(300,38)
	creation_panel.add_child(name_edit)
	hair_label = _label_to_panel("Hair: Dark", Vector2(28,145), 15)
	_add_choice_button("Dark", Vector2(28,172), func(): _choose_hair("dark"))
	_add_choice_button("Ember", Vector2(118,172), func(): _choose_hair("ember"))
	_add_choice_button("Gold", Vector2(208,172), func(): _choose_hair("gold"))
	coat_label = _label_to_panel("Coat: Teal", Vector2(28,215), 15)
	_add_choice_button("Teal", Vector2(28,242), func(): _choose_coat("teal"))
	_add_choice_button("Wine", Vector2(118,242), func(): _choose_coat("wine"))
	_add_choice_button("Ochre", Vector2(208,242), func(): _choose_coat("ochre"))
	var begin := Button.new()
	begin.add_theme_stylebox_override("normal", button_style)
	begin.text = "BEGIN JOURNEY"
	begin.position = Vector2(28,286)
	begin.size = Vector2(300,44)
	begin.pressed.connect(_finish_creation)
	creation_panel.add_child(begin)

	preview_back = _preview_sprite(PREVIEW_BACK)
	preview_boots = _preview_sprite(PREVIEW_BOOTS)
	preview_trousers = _preview_sprite(PREVIEW_TROUSERS)
	preview_shirt = _preview_sprite(PREVIEW_SHIRT)
	preview_body = _preview_sprite(PREVIEW_BODY)
	preview_face = _preview_sprite(PREVIEW_FACE)
	preview_coat = _preview_sprite(PREVIEW_COAT)
	preview_hair = _preview_sprite(PREVIEW_HAIR)
	preview_accessory = _preview_sprite(PREVIEW_ACCESSORY)
	for sprite in [preview_back, preview_boots, preview_trousers, preview_shirt, preview_body, preview_face, preview_coat, preview_hair, preview_accessory]:
		sprite.position = Vector2(420,178)
		sprite.scale = Vector2(3.0,3.0)
		creation_panel.add_child(sprite)
	var preview_label := _creation_label("YOUR WAYFARER", Vector2(356,70), 12)
	preview_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_label.size = Vector2(128,24)
	_update_preview()

func _preview_sprite(texture: Texture2D) -> Sprite2D:
	var s:=Sprite2D.new()
	s.texture=texture
	s.region_enabled=true
	s.region_rect=Rect2(0,0,32,32)
	s.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
	return s

func _update_preview() -> void:
	if preview_hair:
		preview_hair.modulate = {"dark":Color("#4b3730"),"ember":Color("#7d4938"),"gold":Color("#9a713e")}.get(selected_hair,Color.WHITE)
	if preview_coat:
		preview_coat.modulate = {"teal":Color("#355f59"),"wine":Color("#704f65"),"ochre":Color("#80633b")}.get(selected_coat,Color.WHITE)
	if preview_accessory: preview_accessory.modulate = Color("#d9b66f")
	if preview_shirt: preview_shirt.modulate = Color("#d0b28a")
	if preview_trousers: preview_trousers.modulate = Color("#4b5660")
	if preview_boots: preview_boots.modulate = Color("#3e3029")
	if preview_back: preview_back.modulate = Color("#674b3b")

func _creation_label(text:String,pos:Vector2,size:int)->Label:
	var l:=Label.new()
	l.text=text
	l.position=pos
	l.add_theme_font_size_override("font_size",size)
	l.add_theme_color_override("font_color",Color("#f3ead2"))
	creation_panel.add_child(l)
	return l

func _label_to_panel(text: String, pos: Vector2, size: int) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", Color("#f3ead2"))
	creation_panel.add_child(l)
	return l

func _add_choice_button(text: String, pos: Vector2, callback: Callable) -> void:
	var b := Button.new()
	b.add_theme_stylebox_override("normal", button_style)
	b.text = text
	b.position = pos
	b.size = Vector2(80,34)
	b.pressed.connect(callback)
	creation_panel.add_child(b)

func _choose_hair(value: String) -> void:
	selected_hair = value
	hair_label.text = "Hair: " + value.capitalize()
	_update_preview()

func _choose_coat(value: String) -> void:
	selected_coat = value
	coat_label.text = "Coat: " + value.capitalize()
	_update_preview()

func _finish_creation() -> void:
	var chosen := name_edit.text.strip_edges()
	if chosen.is_empty():
		chosen = "Wayfarer"
	state.character["name"] = chosen
	state.character["hair"] = selected_hair
	state.character["coat"] = selected_coat
	creation_panel.visible = false
	creation_finished.emit()

func _build_settings_panel() -> void:
	settings_panel = Panel.new()
	settings_panel.add_theme_stylebox_override("panel", panel_style)
	settings_panel.position = Vector2(230,72)
	settings_panel.size = Vector2(500,410)
	settings_panel.visible = false
	add_child(settings_panel)
	var title := _label_to_panel_at(settings_panel, "GRAPHICS & ACCESSIBILITY", Vector2(24,18), 22)
	_label_to_panel_at(settings_panel, "These settings are saved locally and also work in the browser demo.", Vector2(24,52), 13)
	_add_check(settings_panel, "Fullscreen", "fullscreen", Vector2(24,88))
	_add_check(settings_panel, "VSync", "vsync", Vector2(250,88))
	_add_check(settings_panel, "Weather effects", "weather_fx", Vector2(24,126))
	_add_check(settings_panel, "Dynamic lighting", "dynamic_lighting", Vector2(250,126))
	_add_check(settings_panel, "Particles & VFX", "particles", Vector2(24,164))
	_add_check(settings_panel, "Animated water", "animated_water", Vector2(250,164))
	_add_check(settings_panel, "Screen shake", "screen_shake", Vector2(24,202))
	_add_check(settings_panel, "Screen flash", "screen_flash", Vector2(250,202))
	_add_check(settings_panel, "Integer pixel scaling", "integer_scaling", Vector2(24,240))
	_add_check(settings_panel, "High contrast UI", "high_contrast", Vector2(250,240))
	var ui_title := _label_to_panel_at(settings_panel, "UI SCALE", Vector2(24,288), 14)
	var ui_slider := HSlider.new()
	ui_slider.min_value = 0.85
	ui_slider.max_value = 1.25
	ui_slider.step = 0.05
	ui_slider.value = 1.0
	ui_slider.position = Vector2(24,315)
	ui_slider.size = Vector2(300,24)
	ui_slider.value_changed.connect(func(v): _set_setting("ui_scale", v))
	settings_panel.add_child(ui_slider)
	var close := Button.new()
	close.text = "Close"
	close.position = Vector2(370,350)
	close.size = Vector2(100,36)
	close.add_theme_stylebox_override("normal", button_style)
	close.pressed.connect(toggle_settings)
	settings_panel.add_child(close)

func _label_to_panel_at(panel: Panel, text: String, pos: Vector2, size: int) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", Color("#f3ead2"))
	panel.add_child(l)
	return l

func _add_check(panel: Panel, label: String, key: String, pos: Vector2) -> void:
	var check := CheckButton.new()
	check.text = label
	check.position = pos
	check.size = Vector2(210,32)
	check.set_meta("setting_key", key)
	check.button_pressed = bool(settings_values.get(key, true))
	check.toggled.connect(func(v): _set_setting(key, v))
	panel.add_child(check)

func _set_setting(key: String, value) -> void:
	settings_values[key] = value
	settings_changed.emit(settings_values)

func set_settings(values: Dictionary) -> void:
	settings_values = values.duplicate(true)
	if settings_panel:
		for child in settings_panel.get_children():
			if child is CheckButton and child.has_meta("setting_key"):
				var key: String = child.get_meta("setting_key")
				if settings_values.has(key):
					child.button_pressed = bool(settings_values[key])

func toggle_settings() -> void:
	if not settings_panel.visible:
		settings_from_start = (not session_active and start_menu != null and start_menu.visible)
		settings_panel.visible = true
		if settings_from_start:
			start_menu.visible = false
	else:
		settings_panel.visible = false
		if settings_from_start and not session_active:
			start_menu.visible = true
	if settings_panel.visible:
		inventory_panel.visible = false
		dialog_panel.visible = false

func _process(_delta: float) -> void:
	if state == null:
		return
	stats_label.visible = session_active
	quest_label.visible = session_active and quest_visible
	prompt_label.visible = session_active
	toast_label.visible = session_active
	if hud_settings_button:
		hud_settings_button.visible = session_active
	creation_panel.visible = (not session_active) and start_menu != null and not start_menu.visible and not settings_panel.visible
	stats_label.text = "%s  •  Day %d  •  %s  •  %02d:%02d\nHP %d/%d   Energy %d/%d   Lv %d   XP %d   Echoes %d  •  Home: %s" % [
		state.character.get("name","Wayfarer"), state.day, state.season, state.hour, state.minute,
		state.hp, state.max_hp, state.energy, state.max_energy, state.level, state.xp, state.echoes, state.home_identity()
	]
	if not state.flags.get("old_road_echo", false):
		quest_label.text = "THE WORLD REMEMBERS\nFind the Echo on the Old Road\n○ Listen to the valley"
	elif not state.flags.get("mara_echo_return", false):
		quest_label.text = "THE WORLD REMEMBERS\nReturn to Mara\n○ Tell her what you heard"
	elif not state.flags.get("glass_orchard_echo", false):
		quest_label.text = "THE WORLD REMEMBERS\nFind the Glass Orchard Echo\n○ Follow the memory"
	elif state.quest_stage < 6:
		quest_label.text = "THE WORLD REMEMBERS\nFind the Sleeping Gate\n○ Optional: test your blade"
	else:
		quest_label.text = "THE WORLD REMEMBERS\nThe valley is remembering\n✓ The Gate has answered"
	if inventory_panel.visible:
		_refresh_inventory()
	if settings_panel and settings_panel.visible and state.character.get("name","") == "":
		settings_panel.visible = false

func set_prompt(prompt: String, toast: String) -> void:
	prompt_label.text = prompt
	toast_label.text = toast

func show_dialogue(title: String, body: String) -> void:
	dialog_panel.visible = true
	dialog_title.text = title
	dialog_text.text = body

func toggle_inventory() -> void:
	inventory_panel.visible = not inventory_panel.visible
	if inventory_panel.visible:
		dialog_panel.visible = false
		_refresh_inventory()

func toggle_quest_visibility() -> void:
	if not session_active:
		return
	quest_visible = not quest_visible
	quest_label.visible = quest_visible

func close_panels() -> void:
	dialog_panel.visible = false
	inventory_panel.visible = false

func _refresh_inventory() -> void:
	inventory_text.text = "INVENTORY

Wood %d  Timber %d  Stone %d  Ore %d
Fish %d  Silverfin %d  Berries %d  Wildflower %d
Mushrooms %d  Herbs %d  Seeds %d  Fruit %d
Meals %d  Memory Shards %d  Decor %d  Antique %d
Trade Tokens %d  Map Fragments %d

SKILLS
Gather %d  Woodcut %d  Mining %d  Forage %d
Fish %d  Farm %d  Cook %d  Craft %d
Build %d  Wayfind %d  Memory %d  Combat %d

HOME
Identity: %s
Level %d   Displays %d   Returns %d
Garden: %s

RELATIONSHIPS
Mara %d/10   Rowan %d/10

MEMORY
Echoes %d   World memories %d
Activity types %d   Achievements %d

CRAFTING
Lamp, fisher rack, herb shelf and archive case become available as your life supplies the right materials." % [
		int(state.inventory.get("wood",0)), int(state.inventory.get("timber",0)),
		int(state.inventory.get("stone",0)), int(state.inventory.get("ore",0)),
		int(state.inventory.get("river_fish",0)), int(state.inventory.get("silverfin",0)),
		int(state.inventory.get("berries",0)), int(state.inventory.get("wildflower",0)),
		int(state.inventory.get("mushrooms",0)), int(state.inventory.get("herbs",0)),
		int(state.inventory.get("seeds",0)), int(state.inventory.get("fruit",0)),
		int(state.inventory.get("cooked_meal",0)), int(state.inventory.get("memory_shard",0)),
		int(state.inventory.get("decor",0)), int(state.inventory.get("antique",0)),
		int(state.inventory.get("trade_token",0)), int(state.inventory.get("map_fragment",0)),
		int(state.skills.get("gathering",1)), int(state.skills.get("woodcutting",1)),
		int(state.skills.get("mining",1)), int(state.skills.get("foraging",1)),
		int(state.skills.get("fishing",1)), int(state.skills.get("farming",1)),
		int(state.skills.get("cooking",1)), int(state.skills.get("crafting",1)),
		int(state.skills.get("building",1)), int(state.skills.get("wayfinding",1)),
		int(state.skills.get("memory",1)), int(state.skills.get("combat",1)),
		state.home_identity(), int(state.home_level), state.home_display_items.size(),
		int(state.home_returns),
		"Ready" if state.garden_ready else "Growing" if state.garden_planted_day > 0 else "Empty",
		state.relationship("mara"), state.relationship("rowan"),
		int(state.echoes), state.world_memory.size(), state.activity_counts.size(), state.achievements.size()
	]

func _craft_lamp() -> void:
	craft_requested.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_panels()
