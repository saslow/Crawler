extends Node

var data_path : String = "user://data0.save"
var current_save_file_id : int = 0

# SAVE DATA #

func save(save_file_id : int = 0) -> void:
	var file = FileAccess.open("data" + str(save_file_id) + ".save", FileAccess.WRITE)
	print("data saved in - " + "data" + str(save_file_id) + ".save")
	
# LOAD DATA #
	
func load_data(save_file_id : int = 0) -> void:
	if FileAccess.file_exists("data" + str(save_file_id) + ".save"):
		var file = FileAccess.open("data" + str(save_file_id) + ".save", FileAccess.READ)
	else:
		print("There is no - " + "data" + str(save_file_id) + ".save")
		clear_data(save_file_id)
		
# CLEAR DATA #
		
func clear_data(save_file_id : int = 0) -> void:
	var file = FileAccess.open("data" + str(save_file_id) + ".save", FileAccess.WRITE)
	print("data cleared in - " + "data" + str(save_file_id) + ".save")
