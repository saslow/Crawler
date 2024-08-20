extends Area2D
class_name Ring

#var is_used : bool = false
var first_player : bool = false
var second_player : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("JUMP0"):
		first_player = false
	if Input.is_action_just_pressed("JUMP1"):
		second_player = false

func _on_body_entered(body):
	if body is Player:
		#is_used = true
		if body == g.player:
			first_player = true
		if body == g.second_player:
			second_player = true
		body.set_deferred("global_position", $Pos.global_position)
		body.get_node("Timers/FirstJumpStateTimer").stop()
		body.get_node("Timers/SecondJumpStateTimer").stop()
		body.state = Player.sm.RING
		
