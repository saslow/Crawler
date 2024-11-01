@tool
extends Area2D
class_name Checkpoint

const NORMAL_COLOR = Color(0.898, 0.455, 0)
const GENERAL_COLOR = Color(0.898, 0, 0)
const ESCAPE_COLOR = Color(0, 1, 0.563)

@export var is_general : bool = false :
	set(v):
		is_general = v
		update_colors()
@export var is_on_escape_only : bool = false :
	set(v):
		is_on_escape_only = v
		update_colors()

func _physics_process(delta):
	if !Engine.is_editor_hint():
		$Label.text = str(monitoring)

func update_colors() -> void:
	if is_general:
		$Shape.debug_color = GENERAL_COLOR
		$Shape.debug_color.a = 0.42
		$Polygon2D.color = GENERAL_COLOR
	else:
		if is_on_escape_only:
			$Shape.debug_color = ESCAPE_COLOR
			$Shape.debug_color.a = 0.42
			$Polygon2D.color = ESCAPE_COLOR
		else:
			$Shape.debug_color = NORMAL_COLOR
			$Shape.debug_color.a = 0.42
			$Polygon2D.color = NORMAL_COLOR

func _ready():
	if !Engine.is_editor_hint():
		g.escape_sequence_restarted.connect(_on_escape_sequence_restarted)
		g.escape_sequence_started.connect(_on_escape_sequence_started)
		#$Label.hide()

func _on_escape_sequence_started():
	if !Engine.is_editor_hint():
		if is_general:
			general_checkpoint()
			checkpoint()
	
func _on_escape_sequence_restarted():
	if !Engine.is_editor_hint():
		if is_general or is_on_escape_only:
			print("general cp restarted")
			modulate.a = 1
			set_deferred("monitoring", true)

func _on_body_entered(body):
	if !Engine.is_editor_hint():
		if is_on_escape_only == g.is_escape:
			if body is Player:
				checkpoint()
		
func general_checkpoint() -> void:
	if !Engine.is_editor_hint():
		g.last_general_checkpoint = global_position
		#g.last_checpoint_depth = get_parent().get_parent().z
		if get_parent() is Player:
			g.general_checkpointed_layer = get_parent().get_parent().get_parent()
		else:
			g.general_checkpointed_layer = get_parent().get_parent()
		modulate.a = 0.4
		set_deferred("monitoring", false)
		
func checkpoint() -> void:
	if !Engine.is_editor_hint():
		g.last_checkpoint = global_position
		#g.last_checpoint_depth = get_parent().get_parent().z
		if get_parent() is Player:
			g.checkpointed_layer = get_parent().get_parent().get_parent()
		else:
			g.checkpointed_layer = get_parent().get_parent()
		modulate.a = 0.4
		set_deferred("monitoring", false)
		
