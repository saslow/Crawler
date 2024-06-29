extends Node2D

@export var state : sm = sm.IDLE
@export var behaviour : behaviours = behaviours.STATIC

@export var min_x_wandering_pos : int = 0
@export var max_x_wandering_pos : int = 0

@onready var b : Enemy = $EnemyTemplate

@export var speed : float = 350

@export_range(-1, 1, 2) var direction : int = -1

var vel_x : Vector2
var vel_y : Vector2

#var start_position : Vector2
var start_direction : int

enum sm{
	IDLE = 0,
	AIR = 1,
	WALKING = 2,
	ANGER = 3,
}

enum behaviours{
	STATIC = 0,
	WANDERING = 1,
}

func _ready():
	start_direction = direction
	#g.player_respawned.connect(_on_player_respawned)
	#start_position = global_position

func _process(delta):
	pass
	
func _physics_process(delta):
	$EnemyTemplate/Label2.text = "STATE: " + str(sm.keys()[state])
	physics_state_machine()
	swap_view_area_direction()
	
	
	b.velocity = vel_x + vel_y
	b.move_and_slide()

func physics_state_machine() -> void:
	match state:
		sm.IDLE:
			rotatable_leveling()
			vel_x.x = lerpf(vel_x.x, 0, 0.3)
			vel_x.y = 0
			floor_detaching()
			floor_sticking()
		sm.WALKING:
			rotatable_leveling()
			floor_detaching()
			floor_sticking()
			movement()
		sm.AIR:
			falling()
			floor_attaching()
		sm.ANGER:
			pass

func floor_attaching() -> void:
	if b.is_on_floor():
		state = sm.IDLE
		$Timers/IdleTimer.start()
		
func floor_detaching() -> void:
	if not(b.is_on_floor()):
		state = sm.AIR

func falling() -> void:
	vel_y.y += g.GRAVITY
	vel_y.y = clampf(vel_y.y, g.MIN_FALLING_VEL_Y, g.MAX_FALLING_VEL_Y)
	
func movement() -> void:
	vel_x.x = lerpf(vel_x.x, direction * speed, 0.1)
	vel_x.y = 0
	
func floor_sticking() -> void:
	if b.is_on_floor():
		if state == sm.IDLE:
			vel_y = -b.get_floor_normal() * 350
		else:
			vel_y.x = 0
			vel_y.x = 0
	
func _on_player_respawned() -> void:
	$Timers/IdleTimer.start()
	vel_y = Vector2.ZERO
	vel_x = Vector2.ZERO
	b.velocity = Vector2.ZERO
	state = sm.IDLE
	direction = start_direction

func rotatable_leveling() -> void:
	$EnemyTemplate/Rotatable.rotation = get_real_floor_angle()

func _on_idle_timer_timeout():
	if behaviour == behaviours.WANDERING:
		state = sm.WALKING
		b.floor_constant_speed = true
		direction = -direction
		
func get_real_floor_angle( rad_to_deg : bool = false) -> float:
	if b.is_on_floor():
		if b.get_floor_normal().x >= 0.0:
			if rad_to_deg:
				return rad_to_deg(b.get_floor_angle())
			else:
				return b.get_floor_angle()
		else:
			if rad_to_deg:
				return -rad_to_deg(b.get_floor_angle())
			else:
				return -b.get_floor_angle()
	else:
		return 0.0
		
func swap_view_area_direction() -> void:
	if direction == -1:
		$EnemyTemplate/Rotatable/DamageHitboxComponent/CollisionShape.position = $EnemyTemplate/Rotatable/LeftEdgeArea.position
	if direction == 1:
		$EnemyTemplate/Rotatable/DamageHitboxComponent/CollisionShape.position = $EnemyTemplate/Rotatable/RightEdgeArea.position
		
func _on_right_edge_area_body_exited(area):
	$Timers/IdleTimer.start()
	b.floor_constant_speed = false
	state = sm.IDLE

func _on_left_edge_area_body_exited(area):
	$Timers/IdleTimer.start()
	b.floor_constant_speed = false
	state = sm.IDLE
	
