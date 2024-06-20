@tool
extends Node2D
class_name Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.current_level = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_player(ID : int) -> CharacterBody2D:
	return get_node("Players/Player" + str(ID))
