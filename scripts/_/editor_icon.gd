@tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		get_parent().visible = false
		EditorInterface.
