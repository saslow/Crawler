@tool
extends Node2D
class_name Level

@export var camera : Camera2D
@export var level_debug_mode_disabled : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.current_level = self
	
	if has_child(0): g.player = get_player(0)
	if has_child(1): g.second_player = get_player(1)
	
	if level_debug_mode_disabled:
		if has_child(0): g.player.global_position = $Players/Origin0.global_position
		if has_child(1): g.second_player.global_position = $Players/Origin1.global_position
	
#func get_room_changer(id : int) -> RoomChanger:
	#return get_folder_of_room_changers().get_child(id)
	
func get_player(ID : int, has_origin : bool = true) -> CharacterBody2D:
	if has_origin:
		return get_node("Players/Origin" + str(ID) + "/Player" + str(ID))
	else:
		return get_node("Players/Player" + str(ID))

func has_child(id : int = 0) -> bool:
	return get_child(id) != null
