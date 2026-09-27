extends CanvasLayer
class_name EverduneUI

signal creation_finished
signal sound_requested(kind: String)

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

	_build_character_creator()

func _build_character_creator() -> void:
	creation_panel = Panel.new()
	creation_panel.add_theme_stylebox_override("panel", panel_style)
	creation_panel.position = Vector2(270,110)
	creation_panel.size = Vector2(420,320)
	add_child(creation_panel)
	_label_to_panel("YOUR WAYFARER", Vector2(28,22), 24)
	_label_to_panel("Choose a name and a simple visual identity.", Vector2(28,58), 14)
	name_edit = LineEdit.new()
	name_edit.placeholder_text = "Wayfarer name"
	name_edit.position = Vector2(28,92)
	name_edit.size = Vector2(364,38)
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
	begin.text = "Begin the journey"
	begin.position = Vector2(250,242)
	begin.size = Vector2(142,42)
	begin.pressed.connect(_finish_creation)
	creation_panel.add_child(begin)

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

func _choose_coat(value: String) -> void:
	selected_coat = value
	coat_label.text = "Coat: " + value.capitalize()

func _finish_creation() -> void:
	var chosen := name_edit.text.strip_edges()
	if chosen.is_empty():
		chosen = "Wayfarer"
	state.character["name"] = chosen
	state.character["hair"] = selected_hair
	state.character["coat"] = selected_coat
	creation_panel.visible = false
	creation_finished.emit()

func _process(_delta: float) -> void:
	if state == null:
		return
	creation_panel.visible = String(state.character.get("name","")).is_empty()
	stats_label.text = "%s  •  Day %d  •  %02d:%02d\nHP %d/%d   Energy %d/%d   Lv %d   XP %d   Echoes %d" % [
		state.character.get("name","Wayfarer"), state.day, state.hour, state.minute,
		state.hp, state.max_hp, state.energy, state.max_energy, state.level, state.xp, state.echoes
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

func close_panels() -> void:
	dialog_panel.visible = false
	inventory_panel.visible = false

func _refresh_inventory() -> void:
	inventory_text.text = "INVENTORY\n\nWood            %d\nStone           %d\nSilverfin       %d\nMemory Shard    %d\nHearthstone     %d\n\nCRAFTING\nTurn Memory Shards into Hearth Lamps." % [
		int(state.inventory.get("wood",0)), int(state.inventory.get("stone",0)),
		int(state.inventory.get("river_fish",0)), int(state.inventory.get("memory_shard",0)),
		int(state.inventory.get("hearthstone",0)),
		int(state.skills.get("gathering",1)), int(state.skills.get("fishing",1)),
		int(state.skills.get("memory",1)), int(state.skills.get("combat",1)),
		int(state.collections.get("silverfin",0)), int(state.collections.get("wood",0)),
		int(state.collections.get("stone",0)), int(state.collections.get("memory_shard",0)),
		state.achievements.size()
	]

func _craft_lamp() -> void:
	if state.craft_hearth_lamp():
		sound_requested.emit("craft")
		show_dialogue("Hearth Lamp", "The lamp hums softly. A fragment of the old Hearthsong now lives in your hands.")
	else:
		show_dialogue("Hearth Lamp", "Requires 3 Wood, 2 Stone and 1 Memory Shard.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_panels()
