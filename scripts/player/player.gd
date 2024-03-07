extends CharacterBody2D

var speed = NORMAL_SPEED
var last_wall : int = 0

var state : sm = sm.CONTROL

const NORMAL_SPEED : int = 850
const MAX_SPEED : int = 1450
const ACCELERATION : float = 0.3
const FRICTION : float = 0.3

enum sm{
	CONTROL = 0,
	HURT = 1,
	STUNNED = 2,
	
	DEBUG = 69,
	
}

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	state_machine()
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func state_machine() -> void:
	match state:
		sm.CONTROL:
			movement()
		sm.HURT:
			pass
		sm.STUNNED:
			pass
		sm.DEBUG:
			pass
			
func movement():
	if Input.get_vector("LEFT", "RIGHT", "UP", "DOWN") != Vector2.ZERO:
		velocity = lerp(velocity, Input.get_vector("LEFT", "RIGHT", "UP", "DOWN") * speed, ACCELERATION)
	else:
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
