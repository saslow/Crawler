extends Camera2D

var current_player_level : float = 1
#const LU : int = -100000
#const RB : int = 100000
var zoomed : bool = false

signal limit_changed(l : float, t : float, r : float, b : float)
signal room_changed(offset_x, offset_y)
signal force_cameras

# SHAKE #
var is_shaking : bool = false
var is_shaking_axis : bool = false
var max_strength: float = 1000
@onready var anim = $AnimationPlayer

var rng = RandomNumberGenerator.new()
var shake_force : float
var main_camera : Camera2D

func _ready():
	enabled = false
	limit_changed.emit(limit_left, limit_top, limit_right, limit_bottom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if g.player != null:
		pos_changing()
		if is_shaking:
			shake_camera()
		if is_shaking_axis:
			shake_camera_axis()
			
		
func shake_camera() -> void:
	var screen_shake_force = ss.screen_shake_mult * shake_force
	offset = Vector2(rng.randf_range(-max_strength, max_strength), rng.randf_range(-max_strength, max_strength)) * get_physics_process_delta_time() * smooth_shake_match($ShakeTimer)
	
func shake_camera_axis() -> void:
	var screen_shake_force = ss.screen_shake_mult * shake_force
	offset = Vector2(rng.randf_range(-max_strength * 1.2, max_strength * 1.2), 0).rotated(g.player.sprite.rotation) * get_physics_process_delta_time() * smooth_shake_match($ShakeTimerAxis)
	
func start_screen_shake(force : float = 1.0, time : float = 1.0) -> void:
	is_shaking = true
	if time > $ShakeTimer.time_left:
		$ShakeTimer.start(time)
	shake_force = force
	
func start_screen_shake_axis(force : float = 1.0, time : float = 1.0) -> void:
	is_shaking_axis = true
	if time > $ShakeTimerAxis.time_left:
		$ShakeTimerAxis.start(time)
	shake_force = force
	
func smooth_shake_match(timer : Timer) -> float:
	var time : float = timer.time_left
	if (timer.wait_time >= time / 4) and (timer.wait_time < time / 2):
		return 1
	elif ((timer.wait_time >= time / 6) and (timer.wait_time < time / 4) ) or ((timer.wait_time >= time / 1.5) and (timer.wait_time < time)):
		return 0.5
	else:
		return 2.0
	
func zoom_in() -> void:
	zoomed = true
	$AnimationPlayer.play("zoom_in")
	
func zoom_out() -> void:
	zoomed = false
	$AnimationPlayer.play("zoom_out")
	
func pos_changing_vertical() -> void:
	global_position.y = g.player.global_position.y
	
func pos_changing_hoizontal() -> void:
	global_position.x = g.player.global_position.x
	
func pos_changing() -> void:
	global_position = g.player.global_position
	
func pos_changing_snapped() -> void:
	global_position.x = snappedf(g.player.global_position.x, 1)
	global_position.y = snappedf(g.player.global_position.y, 1)

func _on_shake_timer_timeout():
	is_shaking = false
	
func _on_shake_timer_axis_timeout():
	is_shaking_axis = false
