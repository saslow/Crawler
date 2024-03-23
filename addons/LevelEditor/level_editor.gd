@tool
extends EditorPlugin

const scene_origin := preload("res://addons/LevelEditor/level_editor.tscn")
var scene_origin_instance

func _enter_tree() -> void:
	scene_origin_instance = scene_origin.instantiate()
	add_control_to_bottom_panel(scene_origin_instance, "Level Editor Menu")

func _exit_tree() -> void:
	remove_control_from_bottom_panel(scene_origin_instance)
