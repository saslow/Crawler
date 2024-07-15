extends Area2D
class_name Checkpoint

func _on_area_entered(area):
	if area is EntityComponentSystem:
		if area.entity_type == EntityComponentSystem.entity_types.CHARACTER:
			g.player.last_checkpoint_position = global_position
			g.second_player.last_checkpoint_position = global_position
			set_deferred("monitoring", false)
			modulate.a = 0.4
