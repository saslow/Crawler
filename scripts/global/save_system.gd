extends Node

var path0 : String = "user://data0.save"
var path1 : String = "user://data1.save"
var path2 : String = "user://data2.save"

var _test_score : int = 0
var temp_level_save : Level3D

func _ready():
	#temp_level_save = get_node("/root/Level3D")
	#clear_data(path0)
	#clear_data(path1)
	#clear_data(path2)
	pass

# SAVE DATA #

#func save_data(path : String = path0) -> void:
	#var file = FileAccess.open(path, FileAccess.WRITE)
	#file.store_var(_test_score)
	#print("data saved in - " + path)
	#
## LOAD DATA #
	#
#func load_data(path : String = path0) -> void:
	#if FileAccess.file_exists(path):
		#var file = FileAccess.open(path, FileAccess.READ)
		#_test_score = file.get_var()
	#else:
		#print("There is no - " + path)
		#clear_data(path)
		#
## CLEAR DATA #
		#
#func clear_data(path : String = path0) -> void:
	#var file = FileAccess.open(path, FileAccess.WRITE)
	#file.store_var(0)
	#_test_score = 0
	#print("data cleared in - " + path)
