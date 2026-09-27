extends Resource
class_name EverduneNPCData

@export var id := ""
@export var display_name := ""
@export var position := Vector2.ZERO
@export var morning_position := Vector2.ZERO
@export var day_position := Vector2.ZERO
@export var evening_position := Vector2.ZERO
@export var routine_speed := 22.0
@export_multiline var default_dialogue := ""
@export_multiline var relationship_dialogue := ""
@export_multiline var evening_dialogue := ""
@export_multiline var post_echo_dialogue := ""
@export var evening_hour := 18
@export var post_echo_flag := ""
@export var met_flag := ""
