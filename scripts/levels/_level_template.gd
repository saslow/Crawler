extends Node2D
class_name Level2D

var ui : CanvasLayer
@export var start_room : Room
var current_room : Room

@export_category("Escape Timer")
@export var mins : int = 1
@export var secs : int = 0

func _ready():
	if !Engine.is_editor_hint():
		g.current_level = self
		ui = $UI
		#for i in get_children():
			#if i is Node2D and i != start_room:
				#visible = false
		current_room = start_room
		change_room_to(start_room)

func change_room_to(new : Room) -> void:
	#if current_room != null:
		##current_room.global_position.x = 100000
		#for i in get_children():
			#if i is Node2D:
				#visible = false
	current_room.visible = false
	#current_room.global_position.x = 100000
	current_room.process_mode = Node.PROCESS_MODE_DISABLED
	current_room = new
	new.global_position = Vector2.ZERO
	new.visible = true
	new.process_mode = Node.PROCESS_MODE_INHERIT
	#g.player.reparent(new.get_p)
