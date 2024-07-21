@tool
extends Node2D
class_name Layer2D

@export var local_camera : Camera2D
@export_range(0, 64) var z : float = 1
@export var transparent : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		#g.current_layer = self
		
		if $Players.get_child_count() > 0:
			g.player = get_player(0)
		if $Players.get_child_count() > 1:
			g.second_player = get_player(1)
	
#func get_room_changer(id : int) -> RoomChanger:
	#return get_folder_of_room_changers().get_child(id)
	
func get_player(ID : int) -> CharacterBody2D:
	return get_node("Players/Player" + str(ID))

func has_child(id : int = 0) -> bool:
	return get_child(id) != null
