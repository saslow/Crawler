extends Camera2D
class_name LinkedCamera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = g.player.global_position
