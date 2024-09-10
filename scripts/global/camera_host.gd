extends Camera2D

var current_player_level : float = 1
#const LU : int = -100000
#const RB : int = 100000


signal limit_changed(l : float, t : float, r : float, b : float)
signal room_changed(offset_x, offset_y)
signal force_cameras

func _ready():
	enabled = false
	limit_changed.emit(limit_left, limit_top, limit_right, limit_bottom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if g.player != null:
		pos_changing()
	
func pos_changing_vertical() -> void:
	global_position.y = g.player.global_position.y
	
func pos_changing_hoizontal() -> void:
	global_position.x = g.player.global_position.x
	
func pos_changing() -> void:
	global_position = g.player.global_position
	
func pos_changing_snapped() -> void:
	global_position.x = snappedf(g.player.global_position.x, 1)
	global_position.y = snappedf(g.player.global_position.y, 1)
