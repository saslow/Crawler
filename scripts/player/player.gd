extends CharacterBody2D

var speed : float = NORMAL_SPEED

##only -1 or 1
@export_range(-1, 1, 2) var last_true_axis : int = 1

var state : sm = sm.GROUND

var is_running : bool = false
var is_running_fast : bool = false
var is_attacking : bool = false
var is_dead : bool = false
var is_bumping : bool = false
var is_releasing : bool
var is_jumping : bool = false
var can_jump : bool = true

const NORMAL_SPEED : int = 500
const JUMP_MAX_SPEED  : int = 1100
const MAX_SPEED : int = 1300
const JUMP_FORCE : int = 650
const ACCELERATION : float = 0.3
const FRICTION : float = 0.1

var last_floor_angle : float
var last_real_floor_angle : float
var last_wall_angle : float
var last_real_wall_angle : float

var last_floor_normal : Vector2
var last_wall_normal : Vector2
var x_vel : Vector2
var y_vel : Vector2

@onready var jump_buffer_timer : Timer = $Timers/JumpInputBuffer

enum sm{
	GROUND = 0,
	HURT = 1,
	STUNNED = 2,
	AIR = 3,
	RUN_STOPPING = 4,
	WALL_SLIDING = 5,
	
	DEBUG = 69,
	
}

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	state_machine(delta)
	
func _physics_process(delta: float) -> void:
	$RayCast2D.target_position = velocity/3
	physics_state_machine(delta)
	
	if is_on_floor():
		last_floor_normal = get_floor_normal()
		last_floor_angle = get_floor_angle()
		last_real_floor_angle = get_real_floor_angle()
	
	velocity = x_vel + y_vel
	
	move_and_slide()
	
func physics_state_machine(delta : float) -> void:
	match state:
		sm.GROUND:
			last_wall_angle = 0.0
			last_real_wall_angle = 0.0
			last_wall_normal = Vector2.ZERO
			$Timers/FloorStickBlockingTimer.stop()
			stop_jump_timers()
			if get_floor_angle() <= PI/4:
				last_true_axis_changing()
			movement(delta)
			jump_start(delta)
			floor_detaching()
			sprite_leveling()
			running()
			if is_releasing:
				y_vel = Vector2.ZERO
			else:
				y_vel = -get_floor_normal() * speed
		sm.AIR:
			#is_releasing = false
			running()
			sprite_rotation_reset()
			jump_input_buffering()
			floor_attaching()
			if $Timers/MovementBlockingTimer.is_stopped():
				movement(delta, 0.5, 0.5)
			
			if $Timers/FirstJumpStateTimer.is_stopped() and $Timers/SecondJumpStateTimer.is_stopped():
				wall_attaching()
				falling(delta)
				is_jumping = false
			else:
				is_jumping = true
				jumping(delta)
		sm.WALL_SLIDING:
			if is_on_wall():
				last_wall_angle = get_wall_angle()
				last_real_wall_angle = get_real_wall_angle()
				last_wall_normal = get_wall_normal()
				
			x_vel = Vector2.ZERO
			
			sprite_rotation_reset()
			running()
			stop_jump_timers()
			if get_wall_angle() > PI/4 or !$Timers/WallSlidingGroundingBlockingTimer.is_stopped():
				if !is_on_floor_only():
					$Timers/WallSlidingGroundingBlockingTimer.start()
					
				if is_on_floor():
					if get_real_floor_angle() > 0:
						y_vel = lerp(y_vel, last_wall_normal.rotated(PI/2) * (700 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.07)
					else:
						y_vel = lerp(y_vel, last_wall_normal.rotated(-PI/2) * (700 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.07)
				else:
					if get_real_wall_angle() > 0:
						y_vel = lerp(y_vel, get_wall_normal().rotated(PI/2) * 700, 0.07)
					else:
						y_vel = lerp(y_vel, get_wall_normal().rotated(-PI/2) * 700, 0.07)
			else:
				falling(delta)
				floor_attaching()
				
			jump_start(delta)
			if is_on_wall() and is_on_floor():
				if get_floor_angle() + get_wall_angle() < rad_to_deg(95):
					state = sm.GROUND
			
			if !is_on_wall():
				floor_detaching()
		sm.HURT:
			pass
		sm.STUNNED:
			if !is_on_floor():
				falling(delta)
			if is_on_wall():
				x_vel.x = get_wall_normal().x * speed/1.5
			else:
				x_vel.x = lerpf(x_vel.x, 0, 0.1)
		sm.RUN_STOPPING:
			pass

		sm.DEBUG:
			pass
			
func state_machine(delta : float):
	match state:
		sm.GROUND:
			pass
		sm.AIR:
			pass
		sm.HURT:
			pass
		sm.STUNNED:
			pass
		sm.RUN_STOPPING:
			pass
			
		sm.DEBUG:
			pass
			
func movement(delta : float, acc_mult : float = 1, fr_mult : float = 1) -> void:
	if ((Input.get_axis("LEFT", "RIGHT") != 0) or (is_running)) and $Timers/SlideTimer.is_stopped():
		if state != sm.AIR:
			if is_running:
				#raw_x_vel = lerpf(raw_x_vel, speed, ACCELERATION / 8 * acc_mult)
				x_vel = lerp(x_vel, get_floor_normal().rotated(PI/2 * last_true_axis) * speed, ACCELERATION / 4 * acc_mult)
			else:
				#raw_x_vel = lerpf(raw_x_vel, speed, ACCELERATION * acc_mult)
				x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT", "RIGHT") * speed, ACCELERATION * acc_mult)
		else:
			if is_running:
				#raw_x_vel = lerpf(raw_x_vel, speed, ACCELERATION / 8 * acc_mult)
				x_vel.x = lerpf(x_vel.x, speed * last_true_axis, ACCELERATION / 4 * acc_mult)
				#x_vel.y = 0
				
			else:
				#raw_x_vel = lerpf(raw_x_vel, speed, ACCELERATION * acc_mult)
				x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT", "RIGHT") * speed, ACCELERATION * acc_mult)
				#x_vel.y = 0
				
	else:
		if state != sm.AIR:
			if is_running:
				#raw_x_vel = lerpf(raw_x_vel, 0, FRICTION / 20 * fr_mult)
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
			else:
				#raw_x_vel = lerpf(raw_x_vel, 0, FRICTION * fr_mult)
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
		else:
			if is_running:
				#raw_x_vel = lerpf(raw_x_vel, 0, FRICTION / 20 * fr_mult)
				x_vel.x = lerpf(x_vel.x, 0, FRICTION * fr_mult)
				x_vel.y = 0
			else:
				#raw_x_vel = lerpf(raw_x_vel, 0, FRICTION * fr_mult)
				x_vel.x = lerpf(x_vel.x, 0, FRICTION * fr_mult)
				x_vel.y = 0
			
#func movement(delta : float, acc_mult : float = 1, fr_mult : float = 1) -> void:
	#if Input.get_axis("LEFT", "RIGHT") != 0 and $Timers/SlideTimer.is_stopped():
		#if is_running:
			#x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT", "RIGHT") * speed, ACCELERATION / 8 * acc_mult)
		#else:
			#x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT", "RIGHT") * speed, ACCELERATION * acc_mult)
	#else:
		#if is_running:
			#x_vel.x = lerpf(x_vel.x, Vector3.ZERO.x, FRICTION / 20 * fr_mult)
		#else:
			#x_vel.x = lerpf(x_vel.x, Vector3.ZERO.x, FRICTION * fr_mult)
		
func running() -> void:
	if Input.is_action_pressed("RUN"):
		if is_on_floor() or state == sm.WALL_SLIDING:
			is_running = true
			speed = move_toward(speed, MAX_SPEED, 24)
			floor_max_angle = PI
		else:
			if is_running:
				floor_max_angle = (3*PI)/4.5

		if get_floor_angle() <= PI/4 and is_running:
			$Timers/RunBufferTimer.start()
	elif !$Timers/RunBufferTimer.is_stopped():
		if is_on_floor():
			is_running = true
			speed = move_toward(speed, MAX_SPEED, 24)
		#x_vel.y = JUMP_FORCE
		
		if Input.is_action_pressed("RUN") and get_floor_angle() <= PI/4:
			$Timers/RunBufferTimer.start()
	else:
		if is_on_floor() or is_on_wall():
			floor_max_angle = PI/4
			is_running = false
			speed = NORMAL_SPEED
#func running() -> void:
	#if ( Input.is_action_pressed("RUN") and Input.get_axis("LEFT", "RIGHT") != 0 ):
		#if not(is_on_floor()):
			#floor_max_angle = (3*PI)/4.5
		#else:
			#floor_max_angle = PI
		#is_running = true
		#
		##if get_wall_angle(true) > 90:
			##$Timers/BumpTimer.start()
			##state = sm.STUNNED
			##speed = lerpf(speed, NORMAL_SPEED, 0.4)
		##else:
		#speed = move_toward(speed, MAX_SPEED, 24)
#
		#if get_floor_angle() <= PI/4:
			#$Timers/RunBufferTimer.start()
	#elif !$Timers/RunBufferTimer.is_stopped():
		#floor_max_angle = PI/4
		#is_running = true
		#x_vel.y = JUMP_FORCE
		##
		##if get_wall_angle(true) > 90:
			##$Timers/BumpTimer.start()
			##state = sm.STUNNED
			##speed = lerpf(speed, NORMAL_SPEED, 0.4)
		##else:
		#speed = move_toward(speed, MAX_SPEED, 24)
		#
		#if Input.is_action_pressed("RUN") and Input.get_axis("LEFT", "RIGHT") != 0 and get_floor_angle() <= PI/4:
			#$Timers/RunBufferTimer.start()
	#else:
		#floor_max_angle = PI/4
		#is_running = false
		#speed = NORMAL_SPEED
		
func floor_attaching() -> void:
	if is_on_floor() and ($Timers/FloorStickBlockingTimer.is_stopped()) and $Timers/MovementBlockingTimer.is_stopped():
		state = sm.GROUND
		
func floor_detaching() -> void:
	if not(is_on_floor()):
		y_vel = Vector2.ZERO
		state = sm.AIR
		
func wall_attaching():
	if is_on_wall() and $Timers/MovementBlockingTimer.is_stopped():
		state = sm.WALL_SLIDING
		
func last_true_axis_changing() -> void:
	if Input.get_axis("LEFT", "RIGHT") != 0:
		last_true_axis = Input.get_axis("LEFT", "RIGHT")
		
func falling(delta : float, gravity_mult : float = 1, max_garvity_velocity : float = 5000) -> void:
	y_vel.y += g.GRAVITY * gravity_mult
	y_vel.y = clampf(y_vel.y, -99_999, max_garvity_velocity)
	y_vel.x = 0
		
func jumping(delta : float) -> void:
	if !$Timers/FirstJumpStateTimer.is_stopped() or !$Timers/SecondJumpStateTimer.is_stopped():
		if is_running:
			if (last_floor_angle <= PI/3):
				y_vel.x = 0
				y_vel.y = -JUMP_FORCE
			#elif ((last_floor_angle > PI/3) and (last_floor_angle <= (3*PI)/4)):
				#$Timers/MovementBlockingTimer.start()
				#if last_real_floor_angle > 0:
					#y_vel.x = MAX_SPEED
				#else:
					#y_vel.x = -MAX_SPEED
				#y_vel.y = -JUMP_FORCE/10
			else:
				#$Timers/MovementBlockingTimer.start()
				y_vel = last_floor_normal * JUMP_FORCE
		else:
			if (last_wall_angle <= PI/3):
				y_vel.x = 0
				y_vel.y = -JUMP_FORCE
			#elif ( (last_wall_angle > PI/4) and ( last_wall_angle <= (3*PI)/4 ) ):
				#$Timers/MovementBlockingTimer.start()
				#if last_real_wall_angle > 0:
					#x_vel.x = JUMP_FORCE
				#else:
					#x_vel.x = -JUMP_FORCE
				#y_vel.y = -JUMP_FORCE
			#else:
				#$Timers/MovementBlockingTimer.start()
				#y_vel = last_floor_normal * JUMP_FORCE
		
	if Input.is_action_just_released("JUMP"):
		can_jump = false
		
func jump_start(delta : float) -> void:
	if (Input.is_action_just_pressed("JUMP") or !$Timers/JumpInputBuffer.is_stopped()):
		#y_vel = Vector2.ZERO
		$Timers/JumpInputBuffer.stop()
		$Timers/FloorStickBlockingTimer.start()
		$Timers/FirstJumpStateTimer.start()
		#can_jump = true8
		if get_floor_angle() > PI/3:
			last_true_axis = -last_true_axis
		state = sm.AIR
		
func jump_input_buffering() -> void:
	if Input.is_action_just_pressed("JUMP"):
		$Timers/JumpInputBuffer.start()
		
func sprite_leveling() -> void:
	$Sprite.rotation = lerp_angle($Sprite.rotation, get_real_floor_angle(), 0.2)
	#$Shape.rotation = get_real_floor_angle()
	
func sprite_rotation_reset() -> void:
	$Sprite.rotation = lerp_angle($Sprite.rotation, 0.0, 0.1)
		
func get_real_wall_angle( rad_to_deg : bool = false) -> float:
	if is_on_wall():
		if rad_to_deg:
			return rad_to_deg( Vector2.UP.angle_to( get_wall_normal() ) )
		else:
			return Vector2.UP.angle_to( get_wall_normal() ) 
	else:
		return 0.0

		is_running_fast = true
		
func get_wall_angle( rad_to_deg : bool = false) -> float:
	if is_on_wall():
		if rad_to_deg:
			return rad_to_deg( abs( Vector2.UP.angle_to( get_wall_normal() ) ) )
		else:
			return abs( Vector2.UP.angle_to( get_wall_normal() ) )
	else:
		return 0.0
		
func get_real_floor_angle( rad_to_deg : bool = false) -> float:
	if is_on_floor():
		if get_floor_normal().x >= 0.0:
			if rad_to_deg:
				return rad_to_deg(get_floor_angle())
			else:
				return get_floor_angle()
		else:
			if rad_to_deg:
				return -rad_to_deg(get_floor_angle())
			else:
				return -get_floor_angle()
	else:
		return 0.0
		
		
func input_is_moving_buttons_just_pressed() -> bool:
	if Input.get_axis("LEFT", "RIGHT") != 0:
		return true
	else:
		return false
		
func stop_jump_timers() -> void:
	$Timers/FirstJumpStateTimer.stop()
	$Timers/SecondJumpStateTimer.stop()
		
func _on_run_stop_timer_timeout() -> void: # $Timers/RunStopTimer
	if !is_running:
		$Timers/SlideTimer.start()

func _on_first_jump_state_timer_timeout() -> void:
	if can_jump == true or Input.is_action_pressed("JUMP"):
		$Timers/SecondJumpStateTimer.start()

func _on_bump_timer_timeout() -> void:
	if is_on_floor():
		state = sm.GROUND
	else:
		state = sm.AIR

