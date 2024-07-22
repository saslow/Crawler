extends Area2D

#@export_range(0, 64, 0.1) var target_layer_z : float = 0
@export var to : Layer2D :
	set(value):
		modulate = Color(1, 1, 1, 1)
		to = value

func _ready():
	if to == null:
		modulate = Color(0, 0 , 0, 0.5)
	#for svp : SubViewport in get_node("/root/Level3D/Viewports").get_children():
		#var layer : Layer2D = svp.get_child(0)
		#if target_layer_z == layer.z:
			#to = layer

func _on_body_entered(body):
	if to != null:
		if body is Player:
			g.current_level.start_mc_transition(to.z)
			g.change_players_layer(to)
			g.player.position.y -= 700
			g.second_player.position = g.player.position
