@tool
extends PathFollow2D
## Template for creating enemies, that follow Path2D
class_name Enemy

var default_progress_ratio : float
var default_progress : float

@export var type : types = types.NORMAL
@export_range(-1, 1, 2) var direction : int = -1 :
	set(v):
		update_sprite_direction(v)
		direction = Vector2(v, 0).normalized().x

enum types {
	NORMAL = 0,
	UNIQUE = 1,
}

#region SIGNALS
signal respawn
signal death
	
func _on_player_injured() -> void:
	#respawn.emit()
	progress = default_progress

func is_on_path() -> bool:
	return get_parent() is Path2D
#endregion

#region MAIN
func _ready():
	#death.connect(connect_lose)
	if !Engine.is_editor_hint():
		
		if sprite_has_texture():
			$Marker.queue_free()
		g.player.injured.connect(_on_player_injured)
		if type == types.NORMAL:
			default_progress_ratio = progress_ratio
			default_progress = progress
#endregion

#region BEHAVIOR
func turn() -> void:
	direction = -direction
	
## Returns true if "direction" > 0, else false
func get_boolean_direction() -> bool:
	if direction > 0:
		return true
	else:
		return false
#endregion


#region SPRITE
func update_sprite_direction(new_dir : int) -> void:
	if direction != new_dir:
		flip_sprite_h()
		
func flip_sprite_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h
		
func sprite_has_texture() -> bool:
	if $Sprite.sprite_frames == null:
		return false
	else:
		return true
#endregion
