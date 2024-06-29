extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = $"../GlobalCamera".position - (Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))/2)
	
	if Input.is_action_just_pressed("cancel"):
		visible = !visible


func _on_main_menu_button_pressed():
	g.change_current_level("res://scenes/menus/main_menu.tscn")
	

func _on_options_pressed():
	pass # Replace with function body.
