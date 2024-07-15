@tool
extends Node2D
class_name Level

@export var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.current_level = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	#if !Engine.is_editor_hint():
		#print($Other/ParallaxBackground/ParallaxLayer/Friezes.global_scale, $Other/ParallaxBackground/ParallaxLayer/Friezes.scale)
	
func get_folder_of_room_changers() -> Node2D:
	return get_node("RoomChangers")
	
func get_room_changer(id : int) -> RoomChanger:
	return get_folder_of_room_changers().get_child(id)
	
func get_player(ID : int) -> CharacterBody2D:
	return get_node("Players/Player" + str(ID))
