extends Node

#signal level_started()

#signal room_changed_to_room_at_id(id : int)
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
		#
func change_current_level_to_packed(level : PackedScene) -> void:
	get_tree().change_scene_to_packed(level)
	#level_started.emit()
			
func change_current_level_to_file(file_path : String) -> void:
	get_tree().change_scene_to_file(file_path)
	#level_started.emit()
	
#func change_players_positions_to_room_changer(id : int) -> void:
	#g.player.global_position = g.current_level.get_room_changer(id).get_new_player_pos(0)
	#g.second_player.global_position = g.current_level.get_room_changer(id).get_new_player_pos(1)
	#
#func change_players_positions_on_room_changing(new_global_pos : Vector2, new_global_position_second : Vector2) -> void:
	#g.player.global_position = new_global_pos
	#g.second_player.global_position = new_global_position_second
