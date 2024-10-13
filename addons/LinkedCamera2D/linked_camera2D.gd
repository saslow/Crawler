@tool
@icon("res://addons/rmsmartshape/assets/icon_editor_handle.svg")
extends Camera2D
class_name LinkedCamera2D

#@export var clone_to_bg : Layer2D
@export var background_limits_offsetted : bool = false
@export var linked_camera : LinkedCamera2D
@export var movement : movement_types = movement_types.NORMAL
enum movement_types{
	NORMAL = 0,
	HORIZONTAL = 1,
	VERTICAL = 2,
}
#var _editor_left_top_limit : Vector2 :
	#set(value):
		#if Engine.is_editor_hint():
			#if value != $LeftTop.global_position:
				#change_left_top_limits()

func _ready():
	#if clone_to_bg == null:
		#modulate = Color(0, 0 , 0, 0.5)
	#else:
		#clone_to_bg.call_deferred("add_child", self)
	if !Engine.is_editor_hint():
		$LeftTop.visible = false
		$RightBottom.visible = false
		
		if background_limits_offsetted:
			limit_left = $LeftTop.global_position.x
			limit_right = $RightBottom.global_position.x
		else:
			limit_left = $LeftTop.global_position.x
			limit_right = $RightBottom.global_position.x
		limit_top = $LeftTop.global_position.y
		limit_bottom = $RightBottom.global_position.y
		$LimitsForeground.queue_free()
		$Limits.queue_free()
		
		ch.limit_changed.connect(_on_limits_changed)
		ch.room_changed.connect(_on_room_changed)
		ch.force_cameras.connect(_on_force_cameras)
		if get_parent() is Layer2D:
			zoom = zoom / get_parent().z
		#limit_left *= get_parent().z
		#limit_right *= get_parent().z
		if get_parent().z > 1:
			limit_left -= 960 * get_parent().z
			limit_right += 960 * get_parent().z

		limit_top *= get_parent().z
		limit_bottom *= get_parent().z
		reset_smoothing()
		
func _process(delta):
	if !Engine.is_editor_hint():
		match movement:
			movement_types.NORMAL:
				global_position.x = ch.global_position.x
				global_position.y = ch.global_position.y * (get_parent().z / ch.current_player_level )
			movement_types.HORIZONTAL:
				global_position.x = ch.global_position.x
			movement_types.VERTICAL:
				global_position.y = ch.global_position.y * (get_parent().z / ch.current_player_level )
	else:
		if background_limits_offsetted:
			$LimitsForeground.points = [Vector2($RightBottom.position.x + 1920, $RightBottom.position.y), Vector2($LeftTop.position.x - 1920, $RightBottom.position.y), Vector2($LeftTop.position.x - 1920, $LeftTop.position.y), Vector2($RightBottom.position.x + 1920, $LeftTop.position.y)]
			$LimitsForeground.visible = true
		else:
			$LimitsForeground.visible = false
			$LimitsForeground.clear_points()
		
		$Limits.points = [$RightBottom.position, Vector2($LeftTop.position.x, $RightBottom.position.y), $LeftTop.position, Vector2($RightBottom.position.x, $LeftTop.position.y)]
		
		$LeftTop/PosX.text = str($LeftTop.global_position.x)
		$LeftTop/PosY.text = str($LeftTop.global_position.y)

		$RightBottom/PosX.text = str($RightBottom.global_position.x)
		$RightBottom/PosY.text = str($RightBottom.global_position.y)

func _on_force_cameras() -> void:
	if !Engine.is_editor_hint():
		position_smoothing_enabled = false
		position_smoothing_enabled = true
		reset_smoothing()

func _on_room_changed(offset_x : float, offset_y : float) -> void:
	if !Engine.is_editor_hint():
		limit_bottom += offset_y
		limit_left += offset_x
		limit_right += offset_x
		limit_top += offset_y

func _on_limits_changed(left : float, top : float, right : float, bottom : float) -> void:
	if !Engine.is_editor_hint():
		limit_left = left
		limit_right = right
		limit_top = top
		limit_bottom = bottom
		print("limits changed")
		#limit_left *= get_parent().z
		#limit_right *= get_parent().z
		if get_parent().z > 1:
			limit_left -= 960 * get_parent().z
			limit_right += 960 * get_parent().z
		limit_top *= get_parent().z
		limit_bottom *= get_parent().z

func change_left_top_limits():
	if Engine.is_editor_hint():
			print("hh")
			limit_left = $LeftTop.global_position.x
			limit_top = $LeftTop.global_position.y

func change_right_bottom_limits():
	if Engine.is_editor_hint():
			limit_right = $RightBottom.global_position.x
			limit_bottom = $RightBottom.global_position.y
