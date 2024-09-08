extends Camera2D
class_name LinkedCamera2D


func _ready():
	if get_parent() is Layer2D:
		zoom = zoom / get_parent().z
		#pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
