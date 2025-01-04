extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("cloud_rotation")

func _physics_process(delta):
	if get_parent().is_visible_in_tree():
		play("cloud_rotation")
	else:
		stop()
