extends Node

var path0 : String = "user://save0.giraffacamelopardalistippelskirchi"
var path1 : String = "user://save1.giraffacamelopardalistippelskirchi"
var path2 : String = "user://save2.giraffacamelopardalistippelskirchi"
var file = ConfigFile.new()

var current_path : String
var current_score : int = 0
var current_treasure_count : int = 0

func _ready():
	pass

func save() -> void:
	file.save(current_path)
	print("file saved at ", current_path)
	pass
	
func load_file() -> void:
	pass

# OPTIONS VARIABLES #

var screen_shake_mult : int = 2
const SCREEN_SHAKE_MULT : int = 2
