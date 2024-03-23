extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body == g.player:
		g.player.is_releasing = true

func _on_body_exited(body: Node2D) -> void:
	if body == g.player:
		g.player.is_releasing = false
