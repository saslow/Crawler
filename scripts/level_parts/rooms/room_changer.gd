extends Area2D
class_name RoomChanger

const PLAYER_OFFSET : int = 312
@export var to_room_changer : RoomChanger
@export var vertical : bool = false
@onready var point0 : Marker2D = $"0"



func _on_body_entered(body):
	if body == g.player:
		#transition()
		g.current_level.ui.anim.play("fade")
		get_tree().paused = true
		await get_tree().create_timer(0.15).timeout
		g.current_level.change_room_to(to_room_changer.get_parent().get_parent().get_parent())
		g.player.call_deferred("reparent", to_room_changer.get_parent().get_parent().get_node("Players"))
		if vertical:
			g.player.global_position = to_room_changer.point0.global_position
		else:
			g.player.global_position.x = to_room_changer.point0.global_position.x
			g.player.global_position.y = to_room_changer.global_position.y - 40
		await get_tree().create_timer(0.15).timeout
		get_tree().paused = false
		print("ffff")
			
func transition() -> void:
	g.current_level.ui.anim.play("fade")
	get_tree().paused = true
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false

#@export var layers_offset_x : int = 10000
#@export var level_offset : Vector2
#@export_category("Cameras")
#@export var forward_camera : LinkedCamera2D
#@export var backward_camera : LinkedCamera2D
#
#
#
#func _ready():
	#layers_offset_x = Vector2(global_position.x, 0).distance_to(Vector2(-16000, 0))
#
#func _on_body_entered(body):
	#origin_shifting(body)
#
#func _on_body_exited(body):
	#pass
	#
#func transition_forward() -> void:
	#g.current_level.UI.anim.play("fade")
	#print_debug("forward")
	#ch.force_cameras.emit()
	#get_tree().paused = true
	#await get_tree().create_timer(0.15).timeout
	#get_tree().paused = false
	#forward_camera.make_current()
	#forward_camera.linked_camera.make_current()
	#get_layer_from_level(0).global_position.x -= layers_offset_x
	#get_layer_from_level(1).global_position.x -= layers_offset_x
	#g.player.global_position.x = global_position.x + PLAYER_OFFSET
	#g.player.global_position.y = global_position.y
	#ch.room_changed.emit(-layers_offset_x, 0)
	#ch.force_cameras.emit()
#
#func transition_backward() -> void:
	#g.current_level.UI.anim.play("fade")
	#print_debug("backward")
	#ch.force_cameras.emit()
	#get_tree().paused = true
	#await get_tree().create_timer(0.15).timeout
	#get_tree().paused = false
	#backward_camera.make_current()
	#backward_camera.linked_camera.make_current()
	#get_layer_from_level(0).global_position.x += layers_offset_x
	#get_layer_from_level(1).global_position.x += layers_offset_x
	#g.player.global_position.x = global_position.x - PLAYER_OFFSET
	#g.player.global_position.y = global_position.y
	#ch.room_changed.emit(layers_offset_x, 0)
	#ch.force_cameras.emit()
#
#func origin_shifting(body) -> void:
	#if !Engine.is_editor_hint():
		#if body is Player:
			#if body.global_position > global_position:
				#transition_backward()
			#else:
				#transition_forward()
#
#func get_layer_from_level(layer : int = 0) -> Layer2D:
	#return g.current_level.get_node("Viewports").get_child(layer).get_child(0).get_child(0)
