extends Line2D

@export var line : Line2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	add_point(g.player.global_position)
	
	if Input.is_action_just_released("JUMP0"):
		var scene = PackedScene.new()
		scene.pack(line)
		ResourceSaver.save(scene, "res://scenes/_/trail.tscn")
