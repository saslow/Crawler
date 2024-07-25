extends Layer2D

func _on_level_1_pressed():
	rc.change_current_level_to_file("res://scenes/levels/level_0r.tscn")

func _on_level_2_pressed():
	rc.change_current_level_to_file("res://scenes/levels/level_1.tscn")
	
func _on_level_3_pressed():
	rc.change_current_level_to_file("res://scenes/levels/level_2.tscn")

func _on_quit_pressed():
	get_tree().quit()

