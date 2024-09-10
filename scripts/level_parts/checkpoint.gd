extends Area2D
class_name Checkpoint

#func _on_area_entered(area):
	#if area is EntityComponentSystem:
		#if area.entity_type == EntityComponentSystem.entity_types.CHARACTER:
			#g.last_checkpoint = global_position
			#g.last_checpoint_depth = get_parent().get_parent().z
			#
			#set_deferred("monitoring", false)
			#modulate.a = 0.4
			#print("fi;kjfi")
			

func _on_body_entered(body):
	if body is Player:
		g.last_checkpoint = global_position
		#g.last_checpoint_depth = get_parent().get_parent().z
		if get_parent() is Player:
			g.checkpointed_layer = get_parent().get_parent().get_parent()
		else:
			g.checkpointed_layer = get_parent().get_parent()
		modulate.a = 0.4
		set_deferred("monitoring", false)
		
