@tool
extends Path2D

@export var spacing : float = 80
@export var debug_spacing : float = 80
@export var shared_progress : float = 0
@export var _add_segment : bool = false : set = add_segment
@export var _delete_segment : bool = false : set = delete_child
@export var _update_segments_progress : bool : set = update_progress

var path_end_progress : float = 0

var segment_shape : Shape2D = load("res://materials/shapes/vein_segment_shape.tres")

func delete_child(value : bool) -> void:
	if get_child_count() > 0:
		get_child(get_child_count() - 1).queue_free()
	
	_delete_segment = false

func add_segment(value : bool) -> void:
	var new_path_follow : PathFollow2D = PathFollow2D.new()
	add_child(new_path_follow)
	new_path_follow.progress = new_path_follow.get_index() * spacing
	
	var new_animatable_body : AnimatableBody2D = AnimatableBody2D.new()
	new_path_follow.add_child(new_animatable_body)
	
	var new_collision_shape : CollisionShape2D = CollisionShape2D.new()
	new_collision_shape.rotation = PI/2
	new_collision_shape.shape = segment_shape
	new_animatable_body.add_child(new_collision_shape)
	_add_segment = false
	
	new_path_follow.owner = self
	new_animatable_body.owner = new_path_follow
	new_collision_shape.owner = new_animatable_body
	
func update_progress(value : bool) -> void:
	if Engine.is_editor_hint():
		for segment in get_children():
			segment.progress = (segment.get_index() * spacing) + shared_progress
		_update_segments_progress = false

func _ready():
	if !Engine.is_editor_hint():
		$PathEnd/Label.visible = false
		$PathActualStart/Label.visible = false

func _process(delta):
	path_end_progress = 2 * ( (get_child_count()-1) * debug_spacing ) - 120
	$PathEnd.progress = path_end_progress
	$PathActualStart.progress = path_end_progress / 2
	if curve != null:
		$PathEnd/Label.text = str(curve.get_baked_length() / 2)
	else:
		$PathEnd/Label.text = "NO CURVE"
	
	if Input.is_action_just_pressed("ui_cancel"):
		$"../AnimationPlayer".play("moving")
	
	if $"../AnimationPlayer".is_playing():
		for segment in get_children():
			if segment.name != "PathEnd":
				segment.progress = (segment.get_index() * spacing) + shared_progress

func _on_trigger_body_entered(body):
	if body is Player:
		$"../Trigger/Shape".set_deferred("disabled", true)
		$"../AnimationPlayer".play("moving")

		
