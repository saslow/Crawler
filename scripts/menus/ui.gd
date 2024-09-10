extends CanvasLayer
class_name UI

@onready var anim : AnimationPlayer = $Anim
@export var border : LinkedCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#ss.load_data(ss.path0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_save_score_pressed():
	pass
	#ss.temp_level_save = get_tree().current_scene
	#ch.limit_changed.emit(-100000, -100000, 100000, 100000)

func _on_load_scene_pressed():
	pass
	#get_tree().current_scene = ss.temp_level_save
	#ch.limit_changed.emit(-12800, -1072, 5376, 1088)
