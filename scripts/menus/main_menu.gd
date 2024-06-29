extends Level

func _on_level_1_pressed():
	g.change_current_level("res://scenes/levels/level_0.tscn")


func _on_level_2_pressed():
	g.change_current_level("res://scenes/levels/level_1.tscn")
	
func _on_level_3_pressed():
	g.change_current_level("res://scenes/levels/level_2.tscn")

func _on_quit_pressed():
	get_tree().quit()

