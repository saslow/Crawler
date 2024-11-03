extends Camera2D

var current_player_level : float = 1
#const LU : int = -100000
#const RB : int = 100000

signal limit_changed(l : float, t : float, r : float, b : float)
signal room_changed(offset_x, offset_y)
signal force_cameras

# SHAKE #
var is_shaking : bool = false
@export var max_strength: float = 30.0

var rng = RandomNumberGenerator.new()
var shake_force : float

func _ready():
	enabled = false
	limit_changed.emit(limit_left, limit_top, limit_right, limit_bottom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if g.player != null:
		pos_changing()
		if is_shaking:
			shake_camera()
		
func shake_camera() -> void:
	var screen_shake_force = ss.screen_shake_mult * shake_force
	offset = Vector2(rng.randf_range(-max_strength, max_strength), rng.randf_range(-max_strength, max_strength))
	
func start_screen_shake(force : float = 1.0, time : float = 1.0) -> void:
	is_shaking = true
	if time > $ShakeTimer.time_left:
		$ShakeTimer.start(time)
	shake_force = force
	
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
