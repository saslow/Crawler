extends CanvasLayer
class_name UI

@onready var anim : AnimationPlayer = $Anim
@export var border : LinkedCamera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#ss.load_data(ss.path0)
	g.times_up.connect(_on_times_up)
	$UI/MissionFailedScreen.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/Scrap.text = str(ss.current_score)
	
func _on_save_score_pressed():
	pass
	#ss.temp_level_save = get_tree().current_scene
	#ch.limit_changed.emit(-100000, -100000, 100000, 100000)

func _on_load_scene_pressed():
	pass
	#get_tree().current_scene = ss.temp_level_save
	#ch.limit_changed.emit(-12800, -1072, 5376, 1088)

func _on_button_pressed():
	if $UI/MissionFailedScreen.visible:
		g.escape_sequence_restarted.emit()
		$UI/MissionFailedScreen.hide()
		
func _on_times_up():
	$UI/MissionFailedScreen.visible = true
