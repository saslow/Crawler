extends Control

@onready var player : Player = get_parent()
#@export var player_camera : Camera2D

func _ready():
	#scale = Vector2(1 / player_camera.zoom.x, 1 / player_camera.zoom.y)
	pass

func _process(delta: float) -> void:
	debug(delta)
	
func debug(delta) -> void:
	$Debug/MonitorsContainer/Fps/Label.text = "   FPS: " + str(Engine.get_frames_per_second())
	$Debug/MonitorsContainer/Speed/Label.text = "   SPEED: " + str( snapped( player.speed, 0.01) )
	$Debug/MonitorsContainer/PosDelta/Label.text = "   ΔPOS: " + str( snapped( player.get_position_delta().length(), 0.01) ) 
	$Debug/MonitorsContainer/State/Label.text = "   STATE: " + str(player.state)
	$Debug/MonitorsContainer/FloorAngle/Label.text = "   R_FLOOR_ANGLE: " + str( snapped( player.get_real_floor_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/WallAngle/Label.text = "   WALL_ANGLE: " + str( snapped( player.get_real_wall_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/JumpBufferIsStopped/Label.text = "   J_B_stopped: " + str(player.jump_buffer_timer.is_stopped())
	$Debug/MonitorsContainer/Vel/Label.text = "   Vel: " + str( player.velocity ) 
	$Debug/MonitorsContainer/YVel/Label.text = "   YVel: " + str( player.y_vel ) 
	$Debug/MonitorsContainer/XVel/Label.text = "   LTA: " + str( player.last_true_axis ) 
	
