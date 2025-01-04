@icon("res://addons/rmsmartshape/assets/icon_editor_handle.svg")
extends Camera2D
class_name LinkedCamera2D

#@export var clone_to_bg : Layer2D
#@export var background_limits_offsetted : bool = false
#@export var linked_camera : LinkedCamera2D
var is_main : bool
var player_z : float
var camera_z : float
@export var closest_camera : bool = false
@export var movement : movement_types = movement_types.NORMAL
enum movement_types{
	NORMAL = 0,
	HORIZONTAL = 1,
	VERTICAL = 2,
	NORMAL_X_MULTIPLIED = 3,
	NORMAL_Y_MULTIPLIED = 4,
}
#
#@onready var rb_handle : Node2D = $RightBottom
#@onready var lt_handle : Node2D = $LeftTop
#
#
#const X_OFFSET : int = 1080
#const Y_OFFSET : int = 772
##var _editor_left_top_limit : Vector2 :
	##set(value):
		##if Engine.is_editor_hint():
			##if value != $LeftTop.global_position:
				##change_left_top_limits()

func depth_offset_x(closest_layer_z : float = g.current_level.current_room.closest_layer_z) -> float: # VAJNO OCHEN' CAPETS JEST' !!!!!!
	return 1920 * (camera_z - closest_layer_z)

func depth_offset_y(closest_layer_z : float = g.current_level.current_room.closest_layer_z) -> float: # VAJNO OCHEN' CAPETS JEST' !!!!!!
	return 1080 * (camera_z - closest_layer_z)

func _ready():
	await get_tree().create_timer(0.001).timeout
	player_z = g.player.get_parent().get_parent().z
	camera_z = get_parent().z
	
	limit_right += depth_offset_x()
	limit_left -= depth_offset_x()
	limit_bottom += depth_offset_y()
	limit_top -= depth_offset_y()

	if get_parent() is Layer2D:
		zoom = (Vector2.ONE * 0.5) / camera_z
	
	##if clone_to_bg == null:
		##modulate = Color(0, 0 , 0, 0.5)
	##else:
		##clone_to_bg.call_deferred("add_child", self)
	#if !Engine.is_editor_hint():
		#$LeftTop.visible = false
		#$RightBottom.visible = false
		#
		##if background_limits_offsetted:
			##limit_left = $LeftTop.global_position.x
			##limit_right = $RightBottom.global_position.x
		##else:
			##limit_left = $LeftTop.global_position.x
			##limit_right = $RightBottom.global_position.x
		##limit_top = $LeftTop.global_position.y
		##limit_bottom = $RightBottom.global_position.y
		##$LimitsForeground.queue_free()
		##$Limits.queue_free()
		#
		##ch.limit_changed.connect(_on_limits_changed)
		##ch.room_changed.connect(_on_room_changed)
		##ch.force_cameras.connect(_on_force_cameras)
		##limit_left *= get_parent().z
		##limit_right *= get_parent().z
		##if get_parent().z > 1:
			##limit_left -= X_OFFSET/2 * get_parent().z
			##limit_right += X_OFFSET/2 * get_parent().z
#
		##limit_top *= get_parent().z
		##limit_bottom *= get_parent().z
		##reset_smoothing()
		#
func _process(delta):
	player_z = g.player.get_parent().get_parent().z
	camera_z = get_parent().z

	if camera_z == player_z:
		is_main = true
		ch.main_camera = self
	else:
		is_main = false

	match movement:
		movement_types.NORMAL:
			global_position = ch.global_position
		movement_types.NORMAL_Y_MULTIPLIED:
			global_position.y = ch.global_position.y * camera_z / player_z
			global_position.x = ch.global_position.x
		movement_types.NORMAL_X_MULTIPLIED:
			global_position.y = ch.global_position.y
			global_position.x = ch.global_position.x * camera_z / player_z

	#limit_left = ch.limit_left
	#limit_right = ch.limit_right
	#limit_top = ch.limit_top
	#limit_bottom = ch.limit_bottom
	offset = ch.offset

	#if !Engine.is_editor_hint():
		#offset = ch.offset
		#
		#match movement:
			#movement_types.NORMAL:
				#global_position.x = ch.global_position.x
				#global_position.y = ch.global_position.y * (get_parent().z / ch.current_player_level )
			#movement_types.HORIZONTAL:
				#global_position.x = ch.global_position.x
			#movement_types.VERTICAL:
				#global_position.y = ch.global_position.y * (get_parent().z / ch.current_player_level )
	#else:
		#if linked_camera != null:
			#linked_camera.rb_handle.global_position = rb_handle.global_position
			#linked_camera.lt_handle.global_position = lt_handle.global_position
		#
		#if background_limits_offsetted:
			#$LimitsForeground.points = [Vector2($RightBottom.position.x + X_OFFSET, $RightBottom.position.y + Y_OFFSET), Vector2($LeftTop.position.x - X_OFFSET, $RightBottom.position.y + Y_OFFSET), Vector2($LeftTop.position.x - X_OFFSET, $LeftTop.position.y - Y_OFFSET), Vector2($RightBottom.position.x + X_OFFSET, $LeftTop.position.y - Y_OFFSET)]
			#$LimitsForeground.visible = true
		#else:
			#$LimitsForeground.visible = false
			#$LimitsForeground.clear_points()
		#
		#$Limits.points = [$RightBottom.position, Vector2($LeftTop.position.x, $RightBottom.position.y), $LeftTop.position, Vector2($RightBottom.position.x, $LeftTop.position.y)]
		#
		#$LeftTop/PosX.text = str($LeftTop.global_position.x)
		#$LeftTop/PosY.text = str($LeftTop.global_position.y)
#
		#$RightBottom/PosX.text = str($RightBottom.global_position.x)
		#$RightBottom/PosY.text = str($RightBottom.global_position.y)
#
#func _on_force_cameras() -> void:
	#if !Engine.is_editor_hint():
		#position_smoothing_enabled = false
		#position_smoothing_enabled = true
		#reset_smoothing()
#
#func _on_room_changed(offset_x : float, offset_y : float) -> void:
	#if !Engine.is_editor_hint():
		#limit_bottom += offset_y
		#limit_left += offset_x
		#limit_right += offset_x
		#limit_top += offset_y
#
#func _on_limits_changed(left : float, top : float, right : float, bottom : float) -> void:
	#if !Engine.is_editor_hint():
		#limit_left = left
		#limit_right = right
		#limit_top = top
		#limit_bottom = bottom
		#print("limits changed")
		##limit_left *= get_parent().z
		##limit_right *= get_parent().z
		#if get_parent().z > 1:
			#limit_left -= 960 * get_parent().z
			#limit_right += 960 * get_parent().z
		#limit_top *= get_parent().z
		#limit_bottom *= get_parent().z
#
#func change_left_top_limits():
	#if Engine.is_editor_hint():
			#print("hh")
			#limit_left = $LeftTop.global_position.x
			#limit_top = $LeftTop.global_position.y
#
#func change_right_bottom_limits():
	#if Engine.is_editor_hint():
			#limit_right = $RightBottom.global_position.x
			#limit_bottom = $RightBottom.global_position.y
