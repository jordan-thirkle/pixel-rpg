extends CanvasLayer
class_name EverduneUI

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

func _ready() -> void:
	layer=100
	_build_ui()

func _build_ui() -> void:
	prompt_label=Label.new()
	prompt_label.position=Vector2(28,492)
	prompt_label.add_theme_font_size_override("font_size",14)
	prompt_label.add_theme_color_override("font_color",Color("#f4e8c5"))
	add_child(prompt_label)
	toast_label=Label.new()
	toast_label.position=Vector2(28,452)
	toast_label.add_theme_font_size_override("font_size",16)
	toast_label.add_theme_color_override("font_color",Color("#f0c96a"))
	add_child(toast_label)
	stats_label=Label.new()
	stats_label.position=Vector2(28,22)
	stats_label.add_theme_font_size_override("font_size",16)
	stats_label.add_theme_color_override("font_color",Color("#f7efd6"))
	add_child(stats_label)
	quest_label=Label.new()
	quest_label.position=Vector2(720,24)
	quest_label.add_theme_font_size_override("font_size",14)
	quest_label.add_theme_color_override("font_color",Color("#f1dfb2"))
	add_child(quest_label)
	dialog_panel=Panel.new()
	dialog_panel.position=Vector2(150,365)
	dialog_panel.size=Vector2(660,120)
	dialog_panel.visible=false
	add_child(dialog_panel)
	dialog_title=Label.new()
	dialog_title.position=Vector2(20,12)
	dialog_title.add_theme_font_size_override("font_size",20)
	dialog_title.add_theme_color_override("font_color",Color("#e7c77b"))
	dialog_panel.add_child(dialog_title)
	dialog_text=Label.new()
	dialog_text.position=Vector2(20,46)
	dialog_text.size=Vector2(620,60)
	dialog_text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	dialog_text.add_theme_font_size_override("font_size",16)
	dialog_text.add_theme_color_override("font_color",Color("#f3ead2"))
	dialog_panel.add_child(dialog_text)
	inventory_panel=Panel.new()
	inventory_panel.position=Vector2(250,105)
	inventory_panel.size=Vector2(460,320)
	inventory_panel.visible=false
	add_child(inventory_panel)
	inventory_text=Label.new()
	inventory_text.position=Vector2(28,24)
	inventory_text.size=Vector2(404,270)
	inventory_text.add_theme_font_size_override("font_size",17)
	inventory_text.add_theme_color_override("font_color",Color("#f3ead2"))
	inventory_panel.add_child(inventory_text)

func _process(_delta:float)->void:
	if state==null:return
	stats_label.text="LARKMERE  •  Day %d  •  %02d:%02d\nHP %d/%d   Energy %d/%d   Lv %d   XP %d   Echoes %d"%[state.day,state.hour,state.minute,state.hp,state.max_hp,state.energy,state.max_energy,state.level,state.xp,state.echoes]
	quest_label.text="THE WORLD REMEMBERS\nFind an Echo on the Old Road\n%s"%("✓ Echo found" if state.flags.get("old_road_echo",false) else "○ Explore the old road")
	if inventory_panel.visible:_refresh_inventory()

func set_prompt(prompt:String,toast:String)->void:
	prompt_label.text=prompt
	toast_label.text=toast

func show_dialogue(title:String,body:String)->void:
	dialog_panel.visible=true
	dialog_title.text=title
	dialog_text.text=body

func toggle_inventory()->void:
	inventory_panel.visible=not inventory_panel.visible
	if inventory_panel.visible:
		dialog_panel.visible=false
		_refresh_inventory()

func close_panels()->void:
	dialog_panel.visible=false
	inventory_panel.visible=false

func _refresh_inventory()->void:
	inventory_text.text="INVENTORY\n\nWood            %d\nStone           %d\nSilverfin       %d\nMemory Shard    %d\nHearthstone     %d\n\nCRAFT\nPress C to craft a Hearth Lamp\n\nSaving: K     Loading: L     Close: I / Esc"%[int(state.inventory.get("wood",0)),int(state.inventory.get("stone",0)),int(state.inventory.get("river_fish",0)),int(state.inventory.get("memory_shard",0)),int(state.inventory.get("hearthstone",0))]

func _unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("ui_cancel"): close_panels()
	elif event is InputEventKey and event.pressed and event.keycode==KEY_C:
		if state.craft_hearth_lamp(): show_dialogue("Crafted","The Hearth Lamp hums softly. It carries a fragment of the old Hearthsong.")
		else: show_dialogue("Hearth Lamp","Requires 3 Wood, 2 Stone and 1 Memory Shard.")
