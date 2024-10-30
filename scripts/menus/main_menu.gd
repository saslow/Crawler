extends Layer2D

#func _ready():
	#ss.load_data()
	
var buttons_select_type : bst = bst.MAIN
enum bst {
	MAIN,
	FILE,
	LEVELS,
}

# MAIN BUTTONS #
func hide_main_buttons() -> void:
	$MainButtons.visible = false
	$MainButtons/Play.disabled = true
	$MainButtons/Button.disabled = true
	$MainButtons/Quit.disabled = true
	
func unhide_main_buttons() -> void:
	$MainButtons.visible = true
	$MainButtons/Play.disabled = false
	$MainButtons/Button.disabled = false
	$MainButtons/Quit.disabled = false

func _on_play_pressed():
	buttons_select_type = bst.FILE
	$FileButtons.visible = true
	$"FileButtons/1".disabled = false
	$"FileButtons/2".disabled = false
	$"FileButtons/3".disabled = false
	$MainButtons.visible = false
	$MainButtons/Play.disabled = true
	$MainButtons/Button.disabled = true
	$MainButtons/Quit.disabled = true

func _on_quit_pressed():
	get_tree().quit()
	
# FILES #

func hide_file_buttons() -> void:
	$FileButtons.visible = false
	$"FileButtons/1".disabled = true
	$"FileButtons/2".disabled = true
	$"FileButtons/3".disabled = true
	
func unhide_file_buttons() -> void:
	$FileButtons.visible = true
	$"FileButtons/1".disabled = false
	$"FileButtons/2".disabled = false
	$"FileButtons/3".disabled = false

func _on_file_first_pressed():
	ss.current_path = ss.path0
	hide_file_buttons()
	unhide_level_buttons()
	buttons_select_type = bst.LEVELS

func _on_file_second_pressed():
	ss.current_path = ss.path1
	hide_file_buttons()
	unhide_level_buttons()
	buttons_select_type = bst.LEVELS

func _on_file_third_pressed():
	ss.current_path = ss.path2
	hide_file_buttons()
	unhide_level_buttons()
	buttons_select_type = bst.LEVELS
	
# LEVELS #
func unhide_level_buttons() -> void:
	$LevelButtons.visible = true
	$LevelButtons/Level1.disabled = false
	$LevelButtons/Level2.disabled = false
	$LevelButtons/Level3.disabled = false
	
func _on_level_1_pressed():
	rc.change_current_level_to_file("res://scenes/levels/leshy's_swamp.tscn")

func _on_level_2_pressed():
	rc.change_current_level_to_file("res://scenes/levels/level_1.tscn")
	
func _on_level_3_pressed():
	rc.change_current_level_to_file("res://scenes/levels/level_2.tscn")
