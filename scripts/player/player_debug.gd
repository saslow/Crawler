extends Control

@onready var player : Player = g.player
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
	$Debug/MonitorsContainer/State/Label.text = "   STATE: " + str(player.sm.keys()[player.state])
	$Debug/MonitorsContainer/FloorAngle/Label.text = "   R_FLOOR_ANGLE: " + str( snapped( player.get_real_floor_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/WallAngle/Label.text = "   WALL_ANGLE: " + str( snapped( player.get_real_wall_angle(true), 0.1 ) )
	$Debug/MonitorsContainer/JumpBufferIsStopped/Label.text = "   J_B_stopped: " + str(player.is_releasing_vertically)
	$Debug/MonitorsContainer/Vel/Label.text = "   Vel: " + str( player.velocity ) 
	$Debug/MonitorsContainer/YVel/Label.text = "   YVel: " + str( player.y_vel ) 
	$Debug/MonitorsContainer/XVel/Label.text = "   is_on_floor(): " + str( player.is_running ) 
	$Debug/MonitorsContainer/Hp/Label.text = "   HP: " + str( player.component_system.hit_points )
	$Debug/MonitorsContainer/Sliding/Label.text = "   IS_REL_V: " + str( player.is_releasing_vertically )
	$Debug/MonitorsContainer/Position/Label.text = "    POS_X: " + str(player.position.x)
	$Debug/MonitorsContainer/Position2/Label.text = "    POS_X_G: " + str(player.global_position.x)
	
################################### TEST


func _on_button_pressed():
	var tree := get_tree()
	tree.debug_collisions_hint = not tree.debug_collisions_hint

	# Traverse tree to call queue_redraw on instances of
	# CollisionShape2D and CollisionPolygon2D.
	var node_stack: Array[Node] = [tree.get_root()]
	while not node_stack.is_empty():
		var node: Node = node_stack.pop_back()
		if is_instance_valid(node):
			if node is CollisionShape2D or node is CollisionPolygon2D:
				node.queue_redraw()
			node_stack.append_array(node.get_children())
	#_showing_collision_shapes = on
#
	#var tree := get_tree()
	#if tree.debug_collisions_hint == on:
		#return
#
	#tree.debug_collisions_hint = on
#
	## Traverse tree to call queue_redraw on instances of CollisionShape2D and CollisionPolygon2D.
	#var node_stack: Array[Node] = [tree.get_root()]
	#while not node_stack.is_empty():
		#var node: Node = node_stack.pop_back()
		#if is_instance_valid(node):
			#if node is CollisionShape2D or node is CollisionPolygon2D:
				#node.queue_redraw()
			#elif node is RayCast3D \
				#or node is GridMap \
				#or node is CollisionShape3D \
				#or node is CollisionPolygon3D \
				#or node is CollisionObject3D \
				#or node is GPUParticlesCollision3D \
				#or node is GPUParticlesCollisionBox3D \
				#or node is GPUParticlesCollisionHeightField3D \
				#or node is GPUParticlesCollisionSDF3D \
				#or node is GPUParticlesCollisionSphere3D:
				## remove and re-add the node to the tree to force a redraw
				## https://github.com/godotengine/godot/blob/26b1fd0d842fa3c2f090ead47e8ea7cd2d6515e1/scene/3d/collision_object_3d.cpp#L39
				#var parent: Node = node.get_parent()
				#if parent:
					#var was_blocking = parent.is_blocking_signals()
					#parent.set_block_signals(true)
					#parent.remove_child(node)
					#parent.add_child(node)
					#parent.set_block_signals(was_blocking)
#
			#node_stack.append_array(node.get_children()) 
