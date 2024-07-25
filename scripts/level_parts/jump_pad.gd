
extends Area2D

#@export_range(0, 64, 0.1) var target_layer_z : float = 0
@export var to : Layer2D :
	set(value):
		modulate = Color(1, 1, 1, 1)
		to = value
@onready var target_position : Node2D = $TargetPosition

func _ready():
	if !Engine.is_editor_hint():
		if to == null:
			modulate = Color(0, 0 , 0, 0.5)
		else:
			$TargetPosition.reparent(to)
		#var grounding_position_ray : RayCast2D = RayCast2D.new()
		#grounding_position_ray.target_position.y = -2160
		#grounding_position_ray.position.y = position.y - 1080
		#to.add_child(grounding_position_ray)
		#target_position = grounding_position_ray.get_collision_point()
	#for svp : SubViewport in get_node("/root/Level3D/Viewports").get_children():
		#var layer : Layer2D = svp.get_child(0)
		#if target_layer_z == layer.z:
			#to = layer

func _on_body_entered(body):
	if to != null:
		if body is Player:
			if !g.current_level.is_mc_transitioning:
				g.current_level.start_mc_transition(to.z)
				g.change_players_layer(to)
				#g.player.position.y -= g.HALF_DEFAULT_RESOLUTION_HEIGHT + 64
				#g.player.set_deferred("position", target_position)
				#g.second_player.set_deferred("position", g.player.position)
				g.player.global_position = target_position.global_position
				g.second_player.global_position = target_position.global_position
				g.player.get_node("Anim").play("rebound")
				g.second_player.get_node("Anim").play("rebound")
