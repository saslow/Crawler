extends PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if progress_ratio < 0.47:
		visible = false
	else:
		visible = true
		
func _physics_process(delta):
	if progress_ratio < 0.47:
		$Collision/Shape.set_deferred("disabled", true)
	else:
		$Collision/Shape.set_deferred("disabled", false)
