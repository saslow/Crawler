@tool
extends Node2D
class_name Level

@export var camera : Camera2D
var current_bg_level_scale : Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		g.background_level_changed.connect(_on_background_level_changed)
	print("fffffff")
	g.current_level = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !Engine.is_editor_hint():
		print($Other/ParallaxBackground/ParallaxLayer/Friezes.global_scale, $Other/ParallaxBackground/ParallaxLayer/Friezes.scale)
	
func get_player(ID : int) -> CharacterBody2D:
	return get_node("Players/Player" + str(ID))

func _on_background_level_changed(value : Vector2) -> void:
	current_bg_level_scale = value
