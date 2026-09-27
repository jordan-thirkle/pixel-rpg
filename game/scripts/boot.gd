extends Node2D
class_name EverduneBoot

const MAIN_SCENE_PATH := "res://scenes/main.tscn"

var progress_bar: ProgressBar
var percent_label: Label
var stage_label: Label
var detail_label: Label
var load_started := false

func _ready() -> void:
    _build()
    var error := ResourceLoader.load_threaded_request(MAIN_SCENE_PATH, "PackedScene", true)
    if error != OK:
        _fail("Could not request the main game scene (error %d)." % error)
        return
    load_started = true
    stage_label.text = "LOADING GAME"
    detail_label.text = "Reading Larkmere Valley and its real dependencies…"

func _process(_delta: float) -> void:
    if not load_started:
        return
    var progress := []
    var status := ResourceLoader.load_threaded_get_status(MAIN_SCENE_PATH, progress)
    var value := 0.0
    if progress.size() > 0:
        value = clampf(float(progress[0]), 0.0, 1.0)
    progress_bar.value = value * 100.0
    percent_label.text = "%d%%" % int(round(value * 100.0))
    detail_label.text = "Loading main scene dependencies • %d%%" % int(round(value * 100.0))
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        stage_label.text = "PREPARING WORLD"
        detail_label.text = "Instantiating the actual game scene…"
        var packed := ResourceLoader.load_threaded_get(MAIN_SCENE_PATH) as PackedScene
        if packed == null:
            _fail("The main game scene loaded without a valid PackedScene.")
            return
        get_tree().root.add_child(packed.instantiate())
        queue_free()
    elif status == ResourceLoader.THREAD_LOAD_FAILED:
        _fail("The game scene could not be loaded. Check the export and resource paths.")
    elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
        _fail("The game scene references an invalid resource.")

func _build() -> void:
    var background := ColorRect.new()
    background.color = Color("#07110e")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var art := TextureRect.new()
    art.texture = load("res://assets/hearthfall_scene.svg")
    art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    art.modulate = Color(1,1,1,0.62)
    add_child(art)

    var shade := ColorRect.new()
    shade.color = Color("#06100d", 0.42)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(shade)

    var title := Label.new()
    title.text = "EVERDUNE"
    title.position = Vector2(0,82)
    title.size = Vector2(960,70)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size",54)
    title.add_theme_color_override("font_color",Color("#f1d59a"))
    title.add_theme_color_override("font_shadow_color",Color("#211b18"))
    title.add_theme_constant_override("shadow_offset_x",3)
    title.add_theme_constant_override("shadow_offset_y",4)
    add_child(title)

    var subtitle := Label.new()
    subtitle.text = "THE WORLD REMEMBERS"
    subtitle.position = Vector2(0,146)
    subtitle.size = Vector2(960,30)
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.add_theme_font_size_override("font_size",15)
    subtitle.add_theme_color_override("font_color",Color("#eadbbd"))
    add_child(subtitle)

    var card := Panel.new()
    card.position = Vector2(270,365)
    card.size = Vector2(420,120)
    var style := StyleBoxFlat.new()
    style.bg_color = Color("#101915",0.90)
    style.border_color = Color("#b48b51",0.95)
    style.set_border_width_all(2)
    card.add_theme_stylebox_override("panel",style)
    add_child(card)

    stage_label=Label.new()
    stage_label.text="STARTING"
    stage_label.position=Vector2(24,18)
    stage_label.size=Vector2(372,24)
    stage_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    stage_label.add_theme_font_size_override("font_size",13)
    stage_label.add_theme_color_override("font_color",Color("#f0d18e"))
    card.add_child(stage_label)

    progress_bar=ProgressBar.new()
    progress_bar.position=Vector2(24,50)
    progress_bar.size=Vector2(372,12)
    progress_bar.min_value=0
    progress_bar.max_value=100
    progress_bar.show_percentage=false
    var bg:=StyleBoxFlat.new()
    bg.bg_color=Color("#24302a")
    bg.set_corner_radius_all(3)
    var fill:=StyleBoxFlat.new()
    fill.bg_color=Color("#d2a85f")
    fill.set_corner_radius_all(3)
    progress_bar.add_theme_stylebox_override("background",bg)
    progress_bar.add_theme_stylebox_override("fill",fill)
    card.add_child(progress_bar)

    percent_label=Label.new()
    percent_label.text="0%"
    percent_label.position=Vector2(24,68)
    percent_label.size=Vector2(372,24)
    percent_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    percent_label.add_theme_font_size_override("font_size",13)
    percent_label.add_theme_color_override("font_color",Color("#f3ead2"))
    card.add_child(percent_label)

    detail_label=Label.new()
    detail_label.text="Preparing…"
    detail_label.position=Vector2(24,90)
    detail_label.size=Vector2(372,24)
    detail_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    detail_label.add_theme_font_size_override("font_size",11)
    detail_label.add_theme_color_override("font_color",Color("#a99c83"))
    card.add_child(detail_label)

func _fail(message:String) -> void:
    load_started=false
    stage_label.text="LOAD FAILED"
    percent_label.text="—"
    detail_label.text=message
    detail_label.add_theme_color_override("font_color",Color("#e99b88"))
