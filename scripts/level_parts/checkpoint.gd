extends Area2D
class_name Checkpoint

@export var is_general : bool = false
@export var is_on_escape_only : bool = false

func _ready():
	if is_general or is_on_escape_only:
		g.times_up.connect(_on_times_up)
		g.escape_sequence_started.connect(_on_general_checkpoint)

#func _on_area_entered(area):
	#if area is EntityComponentSystem:
		#if area.entity_type == EntityComponentSystem.entity_types.CHARACTER:
			#g.last_checkpoint = global_position
			#g.last_checpoint_depth = get_parent().get_parent().z
			#
			#set_deferred("monitoring", false)
			#modulate.a = 0.4
			#print("fi;kjfi")
			

func _on_general_checkpoint():
	checkpoint()
	general_checkpoint()
	
func _on_times_up():
	modulate.a = 1
	set_deferred("monitoring", true)

func _on_body_entered(body):
	if is_on_escape_only == g.is_escape:
		if body is Player:
			checkpoint()
		
func general_checkpoint() -> void:
	g.last_general_checkpoint = global_position
	#g.last_checpoint_depth = get_parent().get_parent().z
	if get_parent() is Player:
		g.general_checkpointed_layer = get_parent().get_parent().get_parent()
	else:
		g.general_checkpointed_layer = get_parent().get_parent()
	modulate.a = 0.4
	set_deferred("monitoring", false)
		
func checkpoint() -> void:
	g.last_checkpoint = global_position
	#g.last_checpoint_depth = get_parent().get_parent().z
	if get_parent() is Player:
		g.checkpointed_layer = get_parent().get_parent().get_parent()
	else:
		g.checkpointed_layer = get_parent().get_parent()
	modulate.a = 0.4
	set_deferred("monitoring", false)
		
