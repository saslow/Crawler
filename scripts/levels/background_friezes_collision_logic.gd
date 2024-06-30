extends Node2D

var scale_of_friezes : int

func _ready():
	g.background_level_changed.connect(_on_background_level_changed)
	if get_parent() is Level:
		print("level")
		scale_of_friezes = 0
		enable_bodies_collision()
	elif get_parent() is ParallaxLayer:
		scale_of_friezes = 1
		disable_bodies_collision()
	if g.background_level_changed.is_connected(_on_background_level_changed):
		print("а вы знали что пельмени придумали удмурты?")
	
func _on_background_level_changed(new_level : int) -> void:
	if new_level == scale_of_friezes:
		enable_bodies_collision()
	else:
		disable_bodies_collision()

func disable_bodies_collision() -> void:
	for body in get_children():
		print("parallax")
		#body.get_node("CollisionPolygon2D").set_deferred("disabled", true)
		body.set_collision_layer_value(1, 0)
		
func enable_bodies_collision() -> void:
	for body in get_children():
		print("flmflkffhfhkj")
		#body.get_node("CollisionPolygon2D").set_deferred("disabled", false)
		body.set_collision_layer_value(1, 1)
