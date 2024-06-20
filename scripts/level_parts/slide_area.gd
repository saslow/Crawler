extends Area2D

#func _physics_process(delta):
	#if g.player_first.is_sliding == true and g.player_second.is_sliding == false:
		#$Blocker0.collision_mask = 12
		#$Blocker1.collision_mask = 12
	#elif g.player_second.is_sliding == true and g.player_first.is_sliding == false:
		#$Blocker0.collision_mask = 10
		#$Blocker1.collision_mask = 10
	#elif g.player_first.is_sliding == true and g.player_second.is_sliding == true:
		#$Blocker0.collision_mask = 8
		#$Blocker1.collision_mask = 8
	#else:
		#$Blocker0.collision_mask = 14
		#$Blocker1.collision_mask = 14

func _on_body_entered(body):
	if (body is Player):
		if body.is_sliding:
			body.is_in_slide_area = true
			body.disable_slide_area_blockers_collision()

func _on_body_exited(body):
	if body is Player:
		if body.is_in_slide_area:
			body.is_in_slide_area = false
			body.enable_slide_area_blockers_collision()
			

