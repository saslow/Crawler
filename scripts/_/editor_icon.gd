extends Node
class_name IconComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		get_parent().queue_free()
