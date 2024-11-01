@tool
extends Area2D

@export var type : types = types.SCRAP :
	set(v):
		type = v
		_update_label()
enum types {
	SCRAP,
	TREASURE,
	BLOOD,
}
@export_range(1, 5, 4) var mult : int = 1 :
	set(v):
		mult = v
		_update_label()
@export var on_escape_only : bool = false :
	set(v):
		change_debug_color()
		on_escape_only = v
		_update_label()

func change_debug_color() -> void:
	if !on_escape_only:
		$Shape.debug_color = Color.CHARTREUSE
	else:
		$Shape.debug_color = Color.AQUA
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_label()
	if !Engine.is_editor_hint():
		if on_escape_only:
			monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_label() -> void:
	$Label.text = str(types.keys()[type]) + " " + str(mult)

func _on_body_entered(body):
	if !Engine.is_editor_hint():
		if body is Player:
			$Shape.disabled = true
			match type:
				types.SCRAP:
					ss.current_score += 1 * mult
				types.TREASURE:
					ss.current_treasure_count += 1
					monitoring = false
				types.BLOOD:
					monitoring = false
