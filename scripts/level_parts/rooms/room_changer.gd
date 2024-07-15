extends Area2D
class_name RoomChanger

#@export var target_level : PackedScene
#@export var target_room_changer_id : int
#@export var mode : modes = modes.NORMAL
#enum modes{
	#NORMAL = 0,
	#GATES = 1,
#}
#@export var built_in_checkpoint : bool = true
#var is_checkpoint_active : bool = true
#
#var first_pos : Vector2
#var second_pos : Vector2
#var is_player_entered : bool = false

## Called when the node enters the scene tree for the first time.
#func _ready():
	#rc.room_changed_to_room_at_id.connect(_on_room_changed)
	#first_pos = $"NewPlayerPositions/0".global_position
	#second_pos = $"NewPlayerPositions/1".global_position
#
#func activate() -> void:
	#is_player_entered = false
	#rc.change_current_level_to_packed(target_level, target_room_changer_id)
	#
#func set_checkpoints() -> void:
	#g.player.last_checkpoint_position = first_pos
	#g.second_player.last_checkpoint_position = second_pos
	#
#func _on_player_entered(body):
	#if body is Player:
		#is_player_entered = true
		#activate()
	#
#func _on_player_exited(body):
	#if body is Player:
		#is_player_entered = false
		#
#func _on_room_changed(id : int) -> void:
	#if get_index() == id:
		#rc.change_players_positions_to_room_changer(id)
		#
#func get_new_player_pos(id : int) -> Vector2:
	#return $NewPlayerPositions.get_child(id).global_position
