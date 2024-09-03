extends Camera2D
class_name LinkedCamera2D


#func _ready():
	#position_smoothing_enabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = g.player.global_position
	
func position_changing_snapped() -> void:
	position.x = snappedf(g.player.global_position.x, 1)
	position.y = snappedf(g.player.global_position.y, 1)
