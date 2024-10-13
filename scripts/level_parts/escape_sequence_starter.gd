extends Node2D

var is_activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().death.connect(_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_death():
	is_activated = true
	g.escape_sequence_started.emit()
	g.is_escape = true
	print("escape activated")
