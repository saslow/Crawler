extends Control

var secs : int = 0
var mins : int = 0
var def_secs : int = 1
var def_mins : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	g.escape_sequence_started.connect(start)
	def_secs = get_parent().get_parent().get_parent().secs
	def_mins = get_parent().get_parent().get_parent().mins
	reset_timer()
	
func start() -> void:
	reset_timer()
	$Timer.start()

func _on_timer_timeout():
	if secs == 0:
		if mins > 0:
			mins -= 1
			secs = 60
	secs -= 1
	$TimeLeft.text = str(mins) + ":" + str(secs)
	
func reset_timer() -> void:
	secs = def_secs
	mins = def_mins

	
