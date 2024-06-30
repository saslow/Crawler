extends CharacterBody2D
class_name Enemy

@export var component_system : EntityComponentSystem
@export var damage_hitbox_component : EntityComponentSystem
@export var reset_pos_on_player_respawned : bool = true

var start_position : Vector2
var is_killed : bool = false
var is_on_bg_level : bool

signal activity_changed(value : bool)
var is_active : bool = true:
	set(value):
		match value:
			true:
				activity_changed.emit(value)
				print("jjjjjjjjj")
				$Rotatable/EntityComponentSystem.set_deferred("monitoring", true)
				$Rotatable/EntityComponentSystem.set_deferred("monitorable", true)
				$Rotatable/DamageHitboxComponent.set_deferred("monitoring", true)
				$Rotatable/DamageHitboxComponent.set_deferred("monitorable", true)
				$CrushArea.set_deferred("monitoring", true)
				$CrushArea.set_deferred("monitorable", true)
			false:
				activity_changed.emit(value)
				print("ggggggg")
				$Rotatable/EntityComponentSystem.set_deferred("monitoring", false)
				$Rotatable/EntityComponentSystem.set_deferred("monitorable", false)
				$Rotatable/DamageHitboxComponent.set_deferred("monitoring", false)
				$Rotatable/DamageHitboxComponent.set_deferred("monitorable", false)
				$CrushArea.set_deferred("monitoring", true)
				$CrushArea.set_deferred("monitorable", true)

signal injured()

func _ready():
	g.background_level_changed.connect(_on_background_level_changed)
	g.player_respawned.connect(_on_player_respawned)
	if get_collision_mask_value(9):
		start_position = global_position
		is_on_bg_level = false
		is_active = true
	else:
		is_on_bg_level = true
		is_active = false
		
func _physics_process(delta):
	if is_on_bg_level == true:
		start_position = get_parent().global_position

func _on_injured():
	print("Enemy killed")
	component_system.hit_points -= 1
	damage_hitbox_component.monitoring = false
	$Label.visible = true
	is_killed = true
	visible = false
	
func _on_player_respawned():
	global_position = start_position
	visible = true
	is_killed = false
	damage_hitbox_component.monitoring = true
	$Label.visible = false
	get_parent()._on_player_respawned()
	
func _on_background_level_changed(value : int) -> void:
	if value == 0:
		match is_on_bg_level:
			false: is_active = true
			true: is_active = false
	else:
		match is_on_bg_level:
			false: is_active = false
			true: is_active = true
