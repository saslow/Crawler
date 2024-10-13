extends PathFollow2D
class_name Enemy

var default_progress_ratio : float
var default_progress : float

@export var type : types = types.NORMAL

enum types {
	NORMAL = 0,
	UNIQUE = 1,
}

signal death
signal respawn

func _ready():
	if type == types.NORMAL:
		default_progress_ratio = progress_ratio
		default_progress = progress
	
func connect_lose() -> void:
	pass
