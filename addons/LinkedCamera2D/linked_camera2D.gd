extends Camera2D
class_name LinkedCamera2D


func _ready():
	if get_parent() is Layer2D:
		zoom = zoom / get_parent().z
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pos_changing()
	
func pos_changing_vertical() -> void:
	position.y = g.player.global_position.y
	
func pos_changing_hoizontal() -> void:
	position.x = g.player.global_position.x
	
func pos_changing() -> void:
	position = g.player.global_position
	
func pos_changing_snapped() -> void:
	position.x = snappedf(g.player.global_position.x, 1)
	position.y = snappedf(g.player.global_position.y, 1)
