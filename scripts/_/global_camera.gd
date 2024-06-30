extends Camera2D

@export var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	reparent(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#global_position = target.global_position
	pass
