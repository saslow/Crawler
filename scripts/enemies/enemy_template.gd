extends PathFollow2D
class_name Enemy

var default_progress_ratio : float
var default_progress : float

signal death
signal respawn

func _ready():
	default_progress_ratio = progress_ratio
	default_progress = progress
	
func connect_lose() -> void:
	pass
