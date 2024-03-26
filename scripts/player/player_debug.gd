extends Control

func _process(delta: float) -> void:
	debug(delta)
	
func debug(delta) -> void:
	$Debug/MonitorsContainer/Fps/Label.text = "   FPS: " + str(Engine.get_frames_per_second())
	$Debug/MonitorsContainer/Speed/Label.text = "   SPEED: " + str( snapped( g.player.speed, 0.01) )
	$Debug/MonitorsContainer/PosDelta/Label.text = "   ΔPOS: " + str( snapped( g.player.get_position_delta().length(), 0.01) ) 
	$Debug/MonitorsContainer/State/Label.text = "   STATE: " + str(g.player.state)
	$Debug/MonitorsContainer/FloorAngle/Label.text = "   R_FLOOR_ANGLE: " + str( snapped( g.player.get_real_floor_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/WallAngle/Label.text = "   WALL_ANGLE: " + str( snapped( g.player.get_real_wall_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/JumpBufferIsStopped/Label.text = "   J_B_stopped: " + str(g.player.jump_buffer_timer.is_stopped())
