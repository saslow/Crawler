@tool
extends Area2D

func _process(delta):
	if Engine.is_editor_hint():
		$UpDirection.text = name

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.state == Player.sm.GROUND:
			body.is_releasing = true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.is_releasing = false
