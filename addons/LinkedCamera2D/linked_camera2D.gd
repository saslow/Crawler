@icon("res://addons/rmsmartshape/assets/icon_editor_handle.svg")
extends Camera2D
class_name LinkedCamera2D

@export var clone_to_bg : Layer2D

func _ready():
	#if clone_to_bg == null:
		#modulate = Color(0, 0 , 0, 0.5)
	#else:
		#clone_to_bg.call_deferred("add_child", self)
	if !Engine.is_editor_hint():
		ch.limit_changed.connect(_on_limits_changed)
		ch.room_changed.connect(_on_room_changed)
		ch.force_cameras.connect(_on_force_cameras)
		if get_parent() is Layer2D:
			zoom = zoom / get_parent().z
		#limit_left *= get_parent().z
		#limit_right *= get_parent().z
		if get_parent().z == 1:
			limit_left += 960
			limit_right -= 960

	limit_top *= get_parent().z
	limit_bottom *= get_parent().z
		
func _process(delta):
	if !Engine.is_editor_hint():
		global_position.x = ch.global_position.x
		global_position.y = ch.global_position.y * (get_parent().z / ch.current_player_level )

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
		if get_parent().z == 1:
			limit_left += 960
			limit_right -= 960
		limit_top *= get_parent().z
		limit_bottom *= get_parent().z
