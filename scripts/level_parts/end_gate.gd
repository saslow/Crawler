extends Area2D

var is_in_area : bool

func _physics_process(delta):
	if is_in_area:
		$Label.visible = true
	else:
		$Label.visible = false

func _on_body_entered(body):
	if g.is_escape:
		if body is Player:
			is_in_area = true

func _on_body_exited(body):
	if body is Player:
		is_in_area = false
