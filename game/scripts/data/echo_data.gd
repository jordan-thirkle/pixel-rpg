extends Resource
class_name EverduneEchoData

@export var id := ""
@export var title := ""
@export_multiline var discovery_text := ""
@export_multiline var repeat_text := ""
@export var prerequisite_flags: Array[String] = []
@export var prerequisite_activities: Dictionary = {}
@export var completion_flag := ""
@export var quest_stage := 0
@export var memory_xp := 0
@export var xp_reward := 0
@export var item_id := ""
@export var item_amount := 0
@export var position := Vector2.ZERO
@export var memory_kind := "place"
@export var knowledge_tag := ""
@export var world_memory_id := ""
@export_multiline var consequence_text := ""
@export var unlock_flags: Array[String] = []
@export var next_echo_ids: Array[String] = []
@export var relationship_bonus := 0
@export var relationship_npc_id := "mara"
