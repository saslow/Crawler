extends CharacterBody2D
class_name Enemy

@export var component_system : EntityComponentSystem
@export var damage_hitbox_component : EntityComponentSystem
@export var reset_pos_on_player_respawned : bool = true

var start_position : Vector2
var is_killed : bool = false
var is_on_bg_level : bool

signal injured()

func _ready():
	g.player_respawned.connect(_on_player_respawned)
	start_position = position
		
func _physics_process(delta):
	pass

func _on_injured():
	print("Enemy killed")
	component_system.hit_points -= 1
	damage_hitbox_component.monitoring = false
	$Label.visible = true
	is_killed = true
	visible = false
	
func _on_player_respawned():
	position = start_position
	visible = true
	is_killed = false
	damage_hitbox_component.monitoring = true
	$Label.visible = false
	get_parent()._on_player_respawned()

