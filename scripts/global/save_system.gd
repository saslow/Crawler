extends Node

var path0 : String = "user://data0.cfg"
var path1 : String = "user://data1.cfg"
var path2 : String = "user://data2.cfg"
var file = ConfigFile.new()

var current_path : String
var points : int = 0

func _ready():
	pass

func save() -> void:
	file.save(current_path)
	pass
	
func load_file() -> void:
	pass
