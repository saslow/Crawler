extends CharacterBody2D
class_name Player

##In the inspector menu represents player looking direction on scene load. Only -1(left) or 1(right). | В инспекторе значение этой переменной влияет на направления взгляда игрока при загрузке уровня. Только -1(лево) или 1(право).
@export_range(-1, 1, 2) var last_true_axis : int = 1 : set = set_last_true_axis
func set_last_true_axis(new_axis : int) -> void:
	if new_axis != last_true_axis and $Timers/TurningTimer.is_stopped() and state == sm.GROUND:
		if is_running:
			if speed < MAX_SPEED - 300:
				$Timers/TurningTimer.start(0.23)
			else:
				$Timers/TurningTimer.start(0.34)
		else:
			$Timers/TurningTimer.start()
		last_true_axis = new_axis

## Index of player in multiplayer mode
@export_range(0, 1) var player_index : player_IDs = player_IDs.FIRST

@export var character_index : characters_IDs = characters_IDs.BOY

##I dont know
@onready var jump_buffer_timer : Timer = $Timers/JumpInputBuffer

##Represents player state. 
var state : sm = sm.GROUND # sm - state machine
var speed : float = NORMAL_SPEED
var last_floor_angle : float
var last_real_floor_angle : float
var last_wall_angle : float
var last_real_wall_angle : float
var last_floor_normal : Vector2
var last_wall_normal : Vector2
var x_vel : Vector2
var y_vel : Vector2

var is_running : bool = false
var is_running_fast : bool = false
var is_attacking : bool = false
var is_dead : bool = false
var is_bumping : bool = false
var is_releasing : bool
var is_jumping : bool = false : set = set_is_jumping
func set_is_jumping(value) -> void:
	is_jumping = value
var can_jump : bool = true

# Anim ++++
var was_running : bool = false
# Anim ----

const NORMAL_SPEED : int = 700
#const JUMP_MAX_SPEED  : int = 1500
const MAX_SPEED : int = 1400
const JUMP_FORCE : int = 650
const ACCELERATION : float = 0.3 # 0 - 1
const FRICTION : float = 0.1 # 0 - 1

# Player states enum. S.M. - state machine
enum sm{
	GROUND = 0,
	HURT = 1,
	STUNNED = 2,
	AIR = 3,
	RUN_STOPPING = 4,
	WALL_SLIDING = 5,
	
	DEBUG = 41,
	
}

enum player_IDs{
	FIRST = 0,
	SECOND = 1
}

enum characters_IDs{
	BOY = 0,
	GIRL = 1
}

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:

	if Input.is_action_just_pressed("JUST_TEST_BUTTON"):
		g.another_character.global_position = g.current_character.global_position

	character_swapped_indicator()
	if is_running:
		if last_true_axis > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	else:
		if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) > 0:
			$Sprite.flip_h = false
		if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) < 0:
			$Sprite.flip_h = true
		
	state_machine(delta)
	
func _physics_process(delta: float) -> void:
	#$VelRay.target_position = velocity/3
	#$YVelRay.target_position = last_floor_normal * 400
	#$XVelRay.target_position = x_vel/3
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
			last_true_axis_changing()
			movement(delta)
			jump_start(delta)
			floor_detaching()
			sprite_leveling()
			running()
			if is_releasing:
				y_vel /= 5
			else:
				y_vel = -get_floor_normal() * speed
		sm.AIR:
			is_releasing = false
			running()
			sprite_rotation_reset()
			jump_input_buffering()
			floor_attaching()
			last_true_axis_changing()
			
			if $Timers/FirstJumpStateTimer.is_stopped() and $Timers/SecondJumpStateTimer.is_stopped():
				if !is_running:
					movement(delta, 0.5, 0.5)
				wall_attaching()
				is_jumping = false
				falling(delta)
			else:
				movement(delta, 0.5, 0.5)
				is_jumping = true
				jump_ceiling_blocker()
				jumping(delta)
		sm.WALL_SLIDING:
			if is_on_wall():
				last_wall_angle = get_wall_angle()
				last_real_wall_angle = get_real_wall_angle()
				last_wall_normal = get_wall_normal()
				
			#x_vel = Vector2.ZERO
			
			if Input.is_action_just_pressed("JUMP" + get_player_index()):
				x_vel.x = Vector2(get_wall_normal().x, 0).normalized().x
			else:
				x_vel.x = Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index())
			x_vel.y = 0
			
			sprite_rotation_reset()
			running()
			stop_jump_timers()
			if get_wall_angle() > PI/4:
				if is_on_floor():
					if get_real_floor_angle() > 0:
						if Input.is_action_pressed("DOWN" + get_player_index()):
							y_vel = lerp(y_vel, last_wall_normal.rotated(PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.04)
						else:
							y_vel = lerp(y_vel, last_wall_normal.rotated(PI/2) * (700 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.02)
					else:
						if Input.is_action_pressed("DOWN" + get_player_index()):
							y_vel = lerp(y_vel, last_wall_normal.rotated(-PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.04)
						else:
							y_vel = lerp(y_vel, last_wall_normal.rotated(-PI/2) * (700 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.02)
				else:
					if get_real_wall_angle() > 0:
						if Input.is_action_pressed("DOWN" + get_player_index()):
							y_vel = lerp(y_vel, get_wall_normal().rotated(PI/2) * 1400, 0.04)
						else:
							y_vel = lerp(y_vel, get_wall_normal().rotated(PI/2) * 700, 0.02)
					else:
						if Input.is_action_pressed("DOWN" + get_player_index()):
							y_vel = lerp(y_vel, get_wall_normal().rotated(-PI/2) * 1400, 0.04)
						else:
							y_vel = lerp(y_vel, get_wall_normal().rotated(-PI/2) * 700, 0.02)
			else:
				falling(delta)
				floor_attaching()
				floor_detaching()
				
			if is_on_wall() and is_on_floor():
				if get_floor_angle() + get_wall_angle() < rad_to_deg(136):
					state = sm.GROUND
			
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
			if get_real_velocity().length() < 100 and !(is_running or Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0):
				$Anim.play("idle")
			else:
				if is_running:
					if get_position_delta().length() < 20:
						$Anim.play("walk_to_run")
					else:
						$Anim.play("run")
				else:
					$Anim.play("walk")
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

func _on_anim_animation_changed(old_name, new_name) -> void:
	pass

func _on_anim_current_animation_changed(name):
	pass
			
func movement(delta : float, acc_mult : float = 1, fr_mult : float = 1) -> void:
	if ((Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0) or (is_running)) and $Timers/SlideTimer.is_stopped() and $Timers/TurningTimer.is_stopped():
		if state != sm.AIR:
			if is_running:
				#$Anim.play("run")
				x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, 1)
			else:
				#$Anim.play("move")
				x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) * speed, ACCELERATION * acc_mult)
				x_vel.y = 0
				#x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, ACCELERATION * acc_mult)
				
		else:
			if is_running:
				#$Anim.play("run")
				x_vel.x = lerpf(x_vel.x, last_true_axis * speed, ACCELERATION * acc_mult)
				x_vel.y = 0
				#x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, ACCELERATION / 6 * acc_mult)
			else:
				#$Anim.play("move")
				x_vel.y = 0
				x_vel.x = lerpf(x_vel.x, Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) * speed, ACCELERATION * acc_mult)
				
	else:
		if state != sm.AIR:
			if is_running:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult / 2)
			else:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
				x_vel.y = 0

		else:
			if is_running:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
			else:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
		
func running() -> void:
	if Input.is_action_just_pressed("RUN" + get_player_index()):
		if is_on_floor() or state == sm.WALL_SLIDING:
			$Anim.play("walk_to_run")
			
	if Input.is_action_pressed("RUN" + get_player_index()):
		if is_on_floor() or state == sm.WALL_SLIDING:
			is_running = true
			if $Timers/TurningTimer.is_stopped():
				speed = move_toward(speed, MAX_SPEED, 15)
			floor_max_angle = PI
		else:
			if is_running:
				floor_max_angle = (3*PI)/4.5
		#if get_floor_angle() <= PI/4 and is_running:
			#$Timers/RunBufferTimer.start()
	#elif !$Timers/RunBufferTimer.is_stopped():
		#if is_on_floor():
			#is_running = true
			#speed = move_toward(speed, MAX_SPEED, 24)
		#
		#if Input.is_action_pressed("RUN" + get_player_index()) and get_floor_angle() <= PI/4:
			#$Timers/RunBufferTimer.start()
	else:
		if is_on_floor():
			is_running = false
			speed = NORMAL_SPEED
		floor_max_angle = PI/4

func floor_attaching() -> void:
	if is_on_floor() and $Timers/FloorStickBlockingTimer.is_stopped():
		#x_vel = Vector2.ZERO
		x_vel.y = 0
		state = sm.GROUND
		
func floor_detaching() -> void:
	if not(is_on_floor()):
		if last_floor_angle > (3*PI)/4:
			last_true_axis = -last_true_axis
		state = sm.AIR
		
func wall_attaching():
	if is_on_wall():
		state = sm.WALL_SLIDING
		
func last_true_axis_changing() -> void:
	if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0:
		last_true_axis = Vector2(Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()), 0).normalized().x
		
func falling(delta : float, gravity_mult : float = 1, max_gravity_velocity : float = 5000) -> void:
	y_vel.y += g.GRAVITY
	y_vel.y = clampf(y_vel.y, -60_000, max_gravity_velocity)
		
func jumping(delta : float) -> void:
	if !$Timers/FirstJumpStateTimer.is_stopped() or !$Timers/SecondJumpStateTimer.is_stopped():
		if is_running:
			if last_floor_angle > deg_to_rad(89) and last_floor_angle < deg_to_rad(91):
				#y_vel = last_floor_normal * (JUMP_FORCE + 500)
				if get_position_delta().y > 0:
					y_vel = (last_floor_normal * (JUMP_FORCE + 300) )
				else:
					y_vel = (last_floor_normal * (JUMP_FORCE + 300) )
			else:
				y_vel = (last_floor_normal * (JUMP_FORCE + 500))
		else:
			if (last_floor_angle <= PI/3):
				y_vel.x = 0
				y_vel.y = -JUMP_FORCE
		
	if Input.is_action_just_released("JUMP" + get_player_index()):
		can_jump = false
		
func jump_start(delta : float) -> void:
	if (Input.is_action_just_pressed("JUMP" + get_player_index())):# or (!$Timers/JumpInputBuffer.is_stopped() and get_floor_angle() > PI/2):
		#y_vel = Vector2.ZERO
		#$Timers/JumpInputBuffer.stop()
		$Timers/FloorStickBlockingTimer.start()
		
		if ( get_floor_angle() > deg_to_rad(89) ):
			if get_floor_angle() > (3*PI)/4:
				$Timers/FirstJumpStateTimer.start(0.15)
			else:
				$Timers/FirstJumpStateTimer.start(0.15)
			if get_real_floor_angle() > 0 and get_position_delta().y < 0:
				last_true_axis = -last_true_axis
			if get_real_floor_angle() < 0 and get_position_delta().y < 0:
				last_true_axis = -last_true_axis
			$Timers/TurningTimer.stop()
		else:
			$Timers/FirstJumpStateTimer.start(0.15)
		state = sm.AIR
		
func jump_input_buffering() -> void:
	if Input.is_action_just_pressed("JUMP" + get_player_index()):
		$Timers/JumpInputBuffer.start()
		
func jump_ceiling_blocker() -> void:
	if is_on_ceiling():
		velocity.y = 0
		y_vel.y = 0
		stop_jump_timers()
		
func sprite_leveling() -> void:
	$Sprite.rotation = lerp_angle($Sprite.rotation, get_real_floor_angle(), 0.2)
	
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
	if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0:
		return true
	else:
		return false
		
func stop_jump_timers() -> void:
	$Timers/FirstJumpStateTimer.stop()
	$Timers/SecondJumpStateTimer.stop()
	
func get_player_index() -> String:
	return str(player_index)
	
#func get_camera() -> PhantomCamera2D:
	#return $Camera
		
func _on_run_stop_timer_timeout() -> void: # $Timers/RunStopTimer
	if !is_running:
		$Timers/SlideTimer.start()

func _on_first_jump_state_timer_timeout() -> void:
	if (can_jump == true or Input.is_action_pressed("JUMP" + get_player_index()) ):# and (last_floor_angle < PI/2):
		$Timers/SecondJumpStateTimer.start()

func _on_bump_timer_timeout() -> void:
	if is_on_floor():
		state = sm.GROUND
	else:
		state = sm.AIR

# test

func character_swapped_indicator():
	if character_index == characters_IDs.BOY:
		$Sprite.self_modulate = Color(1, 1, 1, 1)
	else:
		$Sprite.self_modulate = Color(1, 0, 0, 1)


func _on_turning_timer_timeout():
	if speed > MAX_SPEED - 300:
		speed = MAX_SPEED - 300
