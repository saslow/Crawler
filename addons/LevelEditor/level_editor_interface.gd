@tool
extends Control

var scene_tree : Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if EditorInterface.get_edited_scene_root() is Level:
		scene_tree = EditorInterface.get_edited_scene_root()

func _on_level_tree_restore_button_pressed() -> void:
	if EditorInterface.get_edited_scene_root() is Level:
		_add_folder_to_tree(scene_tree, "TileMaps")
		_add_folder_to_tree(scene_tree, "Karusels")
		_add_folder_to_tree(scene_tree, "Enemies")
		_add_folder_to_tree(scene_tree, "Players")

func _add_folder_to_tree(parent : Node2D, folder_name : String) -> void:
	if !parent.has_node(folder_name):
		var new_folder : Node2D = Node2D.new()
		parent.add_child(new_folder)
		new_folder.owner = parent
		new_folder.name = folder_name

