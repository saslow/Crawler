extends Node

@export var shadow_scale : float = 1
var ray : RayCast2D
var shadow : Node2D

func _ready():
	#shadow.scale = shadow.scale * shadow_scale
	ray = get_node("ShadowRay")
	shadow = get_node("ShadowRay/Polygon2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(str(get_ray_lenght()) + " " + str(get_ray_lenght()/321))
	
	if ray.is_colliding():
		shadow.global_position = ray.get_collision_point()
		shadow.rotation = lerp(shadow.rotation, Vector2.UP.angle_to(ray.get_collision_normal()), 0.2)
		shadow.scale = Vector2((1 - get_ray_lenght_percentage()) * shadow_scale, 1 - get_ray_lenght_percentage())
	else:
		shadow.scale = lerp(shadow.scale, Vector2.ZERO, 0.3)
	
func get_ray_lenght_percentage() -> float:
	return get_ray_lenght()/400

func get_ray_lenght() -> float:
	return ray.global_position.distance_to(ray.get_collision_point())
