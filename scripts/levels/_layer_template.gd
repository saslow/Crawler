@tool
extends Node2D
class_name Layer2D

@export var ss2d_material_shape : SS2D_Material_Shape :
	set(material):
		if Engine.is_editor_hint():
			if material != null:
				if get_node("Friezes").get_child_count() > 0:
					for frieze : SS2D_Shape in get_node("Friezes").get_children():
						if !frieze.is_platform and !frieze.ignore_global_material_change:
							frieze.shape_material = material
		ss2d_material_shape = material

@export_range(0, 64, 0.1) var z : float = 1
@export var transparent : bool = true

#func _process(delta):
	#if !Engine.is_editor_hint():
		#if Input.is_action_just_pressed("UP0"):
			#global_position.x -= 10000
	#if global_position.x > 0:
		#global_position.x = 0
		
# Called when the node enters the scene tree for the first time.

#func _ready() -> void:
	#if !Engine.is_editor_hint():
		#g.current_layer = self
		
		#if $Players.get_child_count() > 0:
			#g.player = get_player(0)
		#if $Players.get_child_count() > 1:
			#g.second_player = get_player(1)
			
	
#func get_room_changer(id : int) -> RoomChanger:
	#return get_folder_of_room_changers().get_child(id)
	
func get_player(ID : int) -> CharacterBody2D:
	return get_node("Players/Player" + str(ID))

func has_child(id : int = 0) -> bool:
	return get_child(id) != null
	
