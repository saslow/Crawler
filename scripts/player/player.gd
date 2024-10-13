extends CharacterBody2D
class_name Player

##In the inspector menu represents player looking direction on scene load. Only -1(left) or 1(right). | В инспекторе значение этой переменной влияет на направления взгляда игрока при загрузке уровня. Только -1(лево) или 1(право).
@export_range(-1, 1, 2) var last_true_axis : int = 1 :
	set(new_axis):
		if new_axis != last_true_axis and $Timers/TurningTimer.is_stopped() and state == sm.GROUND:
			if !is_grinding:
				if is_running:
					if speed < MAX_SPEED - 300:
						$Timers/TurningTimer.start(0.23)
					else:
						$Timers/TurningTimer.start(0.34)
				else:
					if $Timers.has_node("TurningTimer"):
						$Timers/TurningTimer.start(0.03)
			is_grinding = false
			last_true_axis = new_axis

## Index of player in multiplayer mode
@export_range(0, 1) var player_index : player_IDs = player_IDs.FIRST

@export var character_index : characters_IDs = characters_IDs.BOY
@export var component_system : EntityComponentSystem

#I dont know (._ . )   (what this line means?)
@onready var jump_buffer_timer : Timer = $Timers/JumpInputBuffer

##Represents player state. 
@export var state : sm = sm.GROUND :
	set(new_state):
		if new_state == sm.GROUND and new_state != state:
			x_vel.y = 0
		if new_state == sm.REBOUND and new_state != state:
			velocity = Vector2.ZERO
			y_vel = Vector2.ZERO
			x_vel = Vector2.ZERO
			$Anim.play("rebound")
		state = new_state
@export var speed : float = NORMAL_SPEED
var last_x_vel_y : float
var last_floor_angle : float
var last_real_floor_angle : float
var last_wall_angle : float
var last_real_wall_angle : float
var rad_entering_angle : float
var last_floor_normal : Vector2
var last_wall_normal : Vector2
var x_vel : Vector2
var y_vel : Vector2

var is_running : bool = false

var is_running_fast : bool = false
var is_attacking : bool = false
var is_dead : bool = false
var is_bumping : bool = false
var is_sliding : bool = false
var is_releasing : bool
var is_releasing_vertically : bool
var is_jumping : bool = false
var is_axis_changing_delayed : bool = false
var is_on_grind_pipe : bool = false
var is_in_slide_area : bool = false
var is_grinding : bool = false
var is_coyote_jump_allowed : bool = false
var _debug_mode : bool = false
var is_cj_allowed: bool = false

var can_jump : bool = true

var normal_collision_shape : = preload("res://materials/shapes/player_normal_collision_shape.tres")
var slide_collision_shape : = preload("res://materials/shapes/player_slide_collision_shape.tres")

# Anim ++++
var was_running : bool = false
# Anim ----

const NORMAL_SPEED : int = 650
const SLIDE_MAX_SPEED  : int = 1000
const MAX_SPEED : int = 1350
const JUMP_FORCE : int = 700
const ACCELERATION : float = 0.3 # 0 - 1
const FRICTION : float = 0.1 # 0 - 1
const NORMAL_LEFT_AND_RIGHT_RAYS_LENGHT : int = 90


signal injured
signal death

# SAVING

var last_checkpoint_position : Vector2

# Player states enum. S.M. - state machine
enum sm{
	GROUND = 0,
	HURT = 1,
	BUMPED = 2,
	AIR = 3,
	RUN_STOPPING = 4,
	WALL_SLIDING = 5,
	REBOUND = 6,
	RING = 7,
	V_ROPE = 8,
	GHOST = 9,
	
	DEBUG = 10,
	
}

enum player_IDs{
	FIRST = 0,
	SECOND = 1
}

enum characters_IDs{
	BOY = 0,
	GIRL = 1
}

# transitions #
@export_category("ANIMATION VARIABLES")
@export var is_movement_blocked : bool = false
@export var is_jump_to_fall_transition : bool
###############

func define_players() -> void:
	match player_index:
		0: g.player = self
		_: g.second_player = self

func _ready() -> void:
	ch.current_player_level = get_parent().get_parent().z
	define_players()
	#Engine.time_scale = 0.1
	g.background_level_changed.connect(_on_background_level_changed)
	last_checkpoint_position = position
	
func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		last_x_vel_y = x_vel.y
		
	if Input.is_action_just_pressed("DEBUG_MODE"):
		if state != sm.DEBUG:
			_debug_mode = true
			$Shape.disabled = true
			velocity = Vector2.ZERO
			x_vel = Vector2.ZERO
			y_vel = Vector2.ZERO
			state = sm.DEBUG
		else:
			_debug_mode = false
			$Shape.disabled = false
			velocity = Vector2.ZERO
			x_vel = Vector2.ZERO
			y_vel = Vector2.ZERO
			state = sm.AIR
		
	if last_true_axis > 0:
		$Rotatable/AttackAreas/AttackArea.position = $Rotatable/AttackAreas/AreaRightPos.position
	else:
		$Rotatable/AttackAreas/AttackArea.position = $Rotatable/AttackAreas/AreaLeftPos.position
	
	#if state != sm.BUMPED:
		#if is_running:
			#if last_true_axis > 0:
				#$Rotatable/Casts/SideCast.target_position = $Rotatable/Casts/RightTargetNormalPos.position
			#else:
				#$Rotatable/Casts/SideCast.target_position = $Rotatable/Casts/LeftTargetNormalPos.position
		#elif is_on_floor():
			#if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) > 0:
				#$Rotatable/Casts/SideCast.target_position = $Rotatable/Casts/RightTargetNormalPos.position
			#if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) < 0:
				#$Rotatable/Casts/SideCast.target_position = $Rotatable/Casts/LeftTargetNormalPos.position
	#$Casts/YVel.target_position = y_vel
	#$Casts/XVel.target_position = velocity
	physics_state_machine(delta)
	if is_on_floor():
		last_floor_normal = get_floor_normal()
		last_floor_angle = get_floor_angle()
		last_real_floor_angle = get_real_floor_angle()

	#if !Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()):
		#x_vel = Vector2.ZERO
	if state != sm.DEBUG and state != sm.REBOUND and state != sm.RING and state != sm.GHOST:
		velocity = x_vel + y_vel
	if state == sm.GROUND:
		if (Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0) or is_running:
			$Timers/StabilityTimer.start()
					
	if $Timers/StabilityTimer.is_stopped() and state == sm.GROUND:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	
	#if state == sm.GROUND:
		#match last_true_axis:
			#-1:
				#$Rotatable/Casts/ReleaseCast.position = $Rotatable/Casts/ReleaseCastLeftPos.position
			#1:
				#$Rotatable/Casts/ReleaseCast.position = $Rotatable/Casts/ReleaseCastRightPos.position
			#
		#if !$Rotatable/Casts/ReleaseCast.is_colliding():
			#is_releasing = true
		#else:
			#is_releasing = false
	
func _process(delta: float) -> void:
	#var fps = Engine.get_frames_per_second()
	#var lerp_interval = velocity / fps
	#var lerp_position = global_transform.origin + lerp_interval
	#
	#if fps > 60:
		#global_transform.origin = lerp(global_transform.origin, lerp_position, 20 * delta)

	#character_swapped_indicator()
	
	if state != sm.BUMPED:
		if is_running:
			if last_true_axis > 0:
				$Sprite.scale.x = 2
			else:
				$Sprite.scale.x = -2
		elif is_on_floor():
			if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) > 0:
				$Sprite.scale.x = 2
			if Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) < 0:
				$Sprite.scale.x = -2

	state_machine(delta)
	


func physics_state_machine(delta : float) -> void:
	if !is_movement_blocked:
		match state:
			sm.GROUND:
					#if ( Input.is_action_just_released("LEFT" + get_player_index()) and !Input.is_action_pressed("RIGHT" + get_player_index()) ) or ( Input.is_action_just_released("RIGHT" + get_player_index()) and !Input.is_action_pressed("LEFT" + get_player_index()) ): 
						#$Timers/StabilityTimer.start()
				is_releasing_vertically = false

				if is_axis_changing_delayed and get_floor_angle() > deg_to_rad(45):
					last_true_axis = -last_true_axis
					$Timers/TurningTimer.stop()
				
				is_axis_changing_delayed = false
				
				last_wall_angle = 0.0
				last_real_wall_angle = 0.0
				last_wall_normal = Vector2.ZERO
				$Timers/FloorStickBlockingTimer.stop()
				stop_jump_timers()
				if !is_axis_changing_delayed and !is_sliding:
					last_true_axis_changing()
				movement(delta)
				if (!$Rotatable/Casts/UpCast0.is_colliding() and !$Rotatable/Casts/UpCast1.is_colliding()):
					jump_start(delta)
				floor_detaching()
				sprite_leveling()
				rotatable_leveling()
				
				#
				
				attack()
				
				grinding()
				slide_dash_start()
				slide_dash()
					
				#
					
				running()
				
				if is_releasing:
					y_vel = Vector2(0, 0)
				else:
					y_vel = -get_floor_normal() * speed
			sm.AIR:
				#is_releasing = false
				#is_sliding = false
				$Timers/SlideDashTimer.paused = true
				#slide_dash()
				running()
				sprite_rotation_reset()
				rotatable_rotation_reset()
				jump_input_buffering()
				#last_true_axis_changing()
				floor_attaching()
				#slide_dash_start()
				attack()
				
				if $Timers/FirstJumpStateTimer.is_stopped() and $Timers/SecondJumpStateTimer.is_stopped():
					if !is_running:
						movement(delta, 0.5, 0.5)
					else:
						if is_releasing:
							if velocity.x < (speed - 150) and velocity.x > -(speed + 150):
								movement_in_air_state_when_running()
					wall_attaching()
					is_jumping = false
					#if is_cj_allowed:
					if is_releasing and !is_releasing_vertically:
						jump_start(delta)
					falling(delta)
				else:
					movement(delta, 0.5, 0.5)
					is_jumping = true
					jump_ceiling_blocker()
					jumping(delta)
			sm.WALL_SLIDING:
				is_sliding = false
				$Timers/SlideDashTimer.paused = false
				$Timers/SlideDashTimer.stop()
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
				rotatable_rotation_reset()
				running()
				stop_jump_timers()
				if get_wall_angle() > PI/4:
					if is_on_floor():
						if get_real_floor_angle() > 0:
							if Input.is_action_pressed("DOWN" + get_player_index()):
								y_vel = lerp(y_vel, last_wall_normal.rotated(PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.04)
							else:
								y_vel = lerp(y_vel, last_wall_normal.rotated(PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.02)
						else:
							if Input.is_action_pressed("DOWN" + get_player_index()):
								y_vel = lerp(y_vel, last_wall_normal.rotated(-PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.04)
							else:
								y_vel = lerp(y_vel, last_wall_normal.rotated(-PI/2) * (1400 * $Timers/WallSlidingGroundingBlockingTimer.time_left * 5), 0.02)
					else:
						if get_real_wall_angle() > 0:
							if Input.is_action_pressed("DOWN" + get_player_index()):
								y_vel = lerp(y_vel, get_wall_normal().rotated(PI/2) * 1400, 0.04)
							else:
								y_vel = lerp(y_vel, get_wall_normal().rotated(PI/2) * 1400, 0.02)
						else:
							if Input.is_action_pressed("DOWN" + get_player_index()):
								y_vel = lerp(y_vel, get_wall_normal().rotated(-PI/2) * 1400, 0.04)
							else:
								y_vel = lerp(y_vel, get_wall_normal().rotated(-PI/2) * 1400, 0.02)
				else:
					falling(delta)
					floor_attaching()
					floor_detaching()
					
				if is_on_wall() and is_on_floor():
					if get_floor_angle() + get_wall_angle() < rad_to_deg(136):
						state = sm.GROUND
				
			sm.HURT:
				pass
			sm.BUMPED:
				#sprite_leveling(1)
				floor_max_angle = PI/4
				is_running = false
				speed = NORMAL_SPEED
				y_vel = Vector2.ZERO
				x_vel = Vector2.ZERO
				velocity = Vector2.ZERO
				$Anim.play("bump")
			sm.RUN_STOPPING:
				pass
			sm.REBOUND:
				y_vel = Vector2.ZERO
				x_vel = Vector2.ZERO
				velocity = Vector2.ZERO
				#$Shape.disabled = true
			sm.RING:
				default_velocity()
				running()
				
				
				#if Input.is_action_pressed("RUN" + get_player_index()):
					#is_running = true
					#
				#else:
					#speed = NORMAL_SPEED
				#last_true_axis = Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index())
				
				if Input.is_action_pressed("JUMP" + get_player_index()) and Input.is_action_pressed("RUN" + get_player_index()):
					speed = MAX_SPEED
				jump_start(delta)
				last_true_axis = -1
				#last_true_axis_changing()
				#global_position = lerp(global_position, )
			sm.V_ROPE:
				default_velocity()
			sm.GHOST:
				velocity = lerp(velocity, Input.get_vector("LEFT" + get_player_index(), "RIGHT" + get_player_index(), "UP" + get_player_index(), "DOWN" + get_player_index()) * 2000, 0.1)
			sm.DEBUG:
				velocity = Input.get_vector("LEFT" + get_player_index(), "RIGHT" + get_player_index(), "UP" + get_player_index(), "DOWN" + get_player_index()) * 2000

			#if Input.is_action_just_pressed("DEBUG_MODE"):
				#_debug_mode = false
				#state = sm.AIR
			

func state_machine(delta : float):
	match state:
		sm.GROUND:
			is_jump_to_fall_transition = false
			if $Anim.current_animation != "rebound":
				if get_real_velocity().length() < 100 and !(is_running or Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0):
					$Anim.play("idle")
				else:
					if is_running:
						if !$Timers/SlideDashTimer.is_stopped():
							$Anim.play("slide")
						elif speed < MAX_SPEED - 10:
							$Anim.play("walk_to_run")
						else:
							$Anim.play("run")
					else:
						if get_real_velocity().length() < 100:
							$Anim.play("idle")
						else:
							$Anim.play("walk")
		sm.AIR:
			if !is_running and !is_releasing:# or is_releasing:
				if $Timers/FirstJumpStateTimer.is_stopped() and $Timers/SecondJumpStateTimer.is_stopped():
					if is_jump_to_fall_transition:
						$Anim.play("jump_to_fall")
					else:
						$Anim.play("fall")
					
				else:
					$Anim.play("jump")
		sm.HURT:
			pass
		sm.BUMPED:
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
	if ((Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0) or (is_running) or (is_sliding)) and $Timers/SlideTimer.is_stopped() and $Timers/TurningTimer.is_stopped():
		if state != sm.AIR:
			if is_running:
				#$Anim.play("run")
				x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, 1)
			elif is_sliding:
				x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * SLIDE_MAX_SPEED, 0.3)
			else:
				#$Anim.play("move")
				x_vel.x = lerpf(x_vel.x, Vector2( Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()), 0 ).normalized().x  * speed, ACCELERATION * acc_mult)
				x_vel.y = 0
				#x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, ACCELERATION * acc_mult)
				
		else:
			if is_running:
				#$Anim.play("run")
				x_vel.x = lerpf(x_vel.x, last_true_axis * speed, ACCELERATION / 6 * acc_mult)
				x_vel.y = 0
				#x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * speed, ACCELERATION / 6 * acc_mult)
			elif is_sliding:
				x_vel = lerp(x_vel, last_floor_normal.rotated(PI/2 * last_true_axis) * SLIDE_MAX_SPEED, 0.3)
			else:
				#$Anim.play("move")
				x_vel.y = 0
				x_vel.x = lerpf(x_vel.x, Vector2( Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()), 0 ).normalized().x * speed, (ACCELERATION * acc_mult)/1.5 )
				
	else:
		if state != sm.AIR:
			if is_running:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult / 2)
			else:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)

		else:
			if is_running:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult)
			else:
				x_vel = lerp(x_vel, Vector2.ZERO, FRICTION * fr_mult / 2)
		
func movement_in_air_state_when_running() -> void:
	is_releasing_vertically = true
	x_vel.x += last_true_axis * speed/24
		
func running() -> void:
	if Input.is_action_pressed("RUN" + get_player_index()) and ( (!($Rotatable/Casts/LeftCast.is_colliding() and last_true_axis == -1 and speed <= 700) and !($Rotatable/Casts/RightCast.is_colliding() and last_true_axis == 1 and speed <= 700)  ) or state == sm.WALL_SLIDING ):
		if is_on_floor() or state == sm.WALL_SLIDING or state == sm.RING:
			is_running = true
			if $Timers/TurningTimer.is_stopped():
				speed = move_toward(speed, MAX_SPEED, 8)
				if ( $Rotatable/Casts/DownCast0.is_colliding() or $Rotatable/Casts/DownCast1.is_colliding() ) and (($Rotatable/Casts/RightCast.is_colliding() and last_true_axis == 1) or ($Rotatable/Casts/LeftCast.is_colliding() and last_true_axis == -1)):
					speed = NORMAL_SPEED
					is_running = false
					floor_max_angle = PI/4
					x_vel = Vector2.ZERO
					y_vel = Vector2.ZERO
					velocity = Vector2.ZERO
					$Shape.scale = Vector2.ONE
					$Rotatable/EntityComponentSystem/CollisionShape.scale.y = 1
					if speed > MAX_SPEED - 10:
						$Timers/BumpTimer.start(1)
					else:
						$Timers/BumpTimer.start(0.4)
					state = sm.BUMPED
				#if $Rotatable/Casts/LeftCast.is_colliding():
					#pass
			floor_max_angle = PI
		else:
			if is_running:
				floor_max_angle = (3*PI)/4.5
	else:
		if is_on_floor():
			is_running = false
			speed = NORMAL_SPEED
		if !is_sliding:
			floor_max_angle = PI/4

func floor_attaching() -> void:
	if is_on_floor() and $Timers/FloorStickBlockingTimer.is_stopped():
		state = sm.GROUND
		$Timers/SlideDashTimer.paused = false
		is_sliding = false
		
func floor_detaching() -> void:
	if not(is_on_floor()):
		if last_floor_angle > deg_to_rad(135):
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
			if last_floor_angle > deg_to_rad(45) and last_floor_angle < deg_to_rad(135):
				#y_vel = last_floor_normal * (JUMP_FORCE + 500)
				if get_real_velocity().y < 40:
					#y_vel = ( last_floor_normal * (JUMP_FORCE + 200)) + Vector2(0, -700)
					y_vel = ( last_floor_normal * (JUMP_FORCE)) + Vector2(0, -700)
				else:
					#y_vel = ( last_floor_normal * (JUMP_FORCE + 200)) + Vector2(0, 500)
					y_vel = ( last_floor_normal * (JUMP_FORCE)) + Vector2(0, 700)
			else:
				#y_vel = (last_floor_normal * (JUMP_FORCE + 500))
				y_vel = (last_floor_normal * (JUMP_FORCE))
		else:
			if (last_floor_angle <= PI/3):
				y_vel.x = 0
				y_vel.y = -JUMP_FORCE
		
	if Input.is_action_just_released("JUMP" + get_player_index()):
		can_jump = false
		
func jump_start(delta : float) -> void:
	if ( Input.is_action_just_pressed("JUMP" + get_player_index())) or (!$Timers/JumpInputBuffer.is_stopped() ) and is_sliding == false:# and get_floor_angle() > PI/2):
		y_vel = Vector2.ZERO
		is_releasing = false
		is_on_grind_pipe = false
		$Timers/JumpInputBuffer.stop()
		$Timers/SlideDashTimer.stop()
		$Timers/FloorStickBlockingTimer.start()
		
		if ( get_floor_angle() > deg_to_rad(45) ) and is_sliding == false:
			if x_vel.y < 0:
				last_true_axis = -last_true_axis
			else:
				is_axis_changing_delayed = true
			if get_floor_angle() > (3*PI)/4:
				$Timers/FirstJumpStateTimer.start(0.15)
			else:
				$Timers/FirstJumpStateTimer.start(0.3)
			#if get_real_floor_angle() > 0 and velocity.y < 40:
				#last_true_axis = -last_true_axis
			#if get_real_floor_angle() < 0 and velocity.y > 40:
			
		elif is_sliding == false:
			$Timers/FirstJumpStateTimer.start(0.15)
		if is_sliding == false:
			$Timers/TurningTimer.stop()
			state = sm.AIR
		
func jump_input_buffering() -> void:
	if Input.is_action_just_pressed("JUMP" + get_player_index()):
		$Timers/JumpInputBuffer.start()
		
func jump_ceiling_blocker() -> void:
	if is_on_ceiling():
		velocity.y = 0
		y_vel.y = 0
		x_vel.y = 0
		stop_jump_timers()
		
func slide_dash_start() -> void:
	#if Input.is_action_just_pressed("3ACTION" + get_player_index()) and is_running:
		#position += -get_floor_normal() * 20
	#if (Input.is_action_pressed("3ACTION" + get_player_index()) and is_running) or ($Rotatable/Casts/DownCast.is_colliding() and ($Rotatable/Casts/UpCast0.is_colliding() or $Rotatable/Casts/UpCast1.is_colliding()) and is_sliding) :
		#$Timers/SlideDashTimer.start()
		#is_sliding = true
	if (Input.is_action_pressed("3ACTION" + get_player_index()) and is_running) or is_in_slide_area == true:
		$Timers/SlideDashTimer.start()
		is_sliding = true
		
func slide_dash() -> void:
	if is_sliding:
		floor_max_angle = PI
		#$Rotatable/GrindArea.position = $Rotatable/GrindAreaPos1.position
		#$Sprite.scale.y = 1 # TEST
		#$Shape.scale = Vector2(0.5, 0.5)
		$Rotatable/EntityComponentSystem/CollisionShape.scale.y = 0.5
	else:
		#$Rotatable/GrindArea.position = $Rotatable/GrindAreaPos0.position
		#$Sprite.scale.y = 2 # TEST
		#$Shape.scale = Vector2.ONE
		$Rotatable/EntityComponentSystem/CollisionShape.scale.y = 1
		
func grinding() -> void:
	if is_on_grind_pipe and is_running and !is_sliding and $Timers/TurningTimer.is_stopped() and is_on_floor() and Input.is_action_just_pressed("DOWN" + get_player_index()):
		is_grinding = true
		#modulate = Color.BLACK
		position += -get_floor_normal() * 72
		apply_floor_snap()
		last_true_axis = -last_true_axis
		is_grinding = false
	#else:
		#modulate = Color(0, 0, 0, 1)
		
func attack() -> void:
	if Input.is_action_just_pressed("1ACTION" + get_player_index()) and $Timers/AttackTimers/AttackTimer.time_left < $Timers/AttackTimers/AttackTimer.wait_time/2 and state != sm.GHOST:
		#$Rotatable/AttackAreas/AttackArea/Shape.disabled = false
		$Rotatable/AttackAreas/AttackArea.monitoring = true
		$Rotatable/AttackAreas/AttackArea/CollisionShape.set_deferred("debug_color", Color(1, 0, 0, 0.3))
		$Timers/AttackTimers/AttackTimer.start()
		
func sprite_leveling(weight : float = 0.2) -> void:
	#if !is_releasing:
	#if $Timers/TurningTimer.is_stopped():
	if $Anim.current_animation != "rebound":
		$Sprite.rotation = lerp_angle($Sprite.rotation, get_real_floor_angle(), weight)
func rotatable_leveling() -> void:
	$Rotatable.rotation = get_real_floor_angle()
	
func sprite_rotation_reset() -> void:
	$Sprite.rotation = lerp_angle($Sprite.rotation, 0.0, 0.1)
	
func rotatable_rotation_reset() -> void:
	$Rotatable.rotation = 0
		
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
		
func stop_jump_timers() -> void:
	$Timers/FirstJumpStateTimer.stop()
	$Timers/SecondJumpStateTimer.stop()
	
func get_player_index() -> String:
	return str(player_index)
	
#func get_camera() -> PhantomCamera2D:
	#return $Camera
	
func disable_slide_area_blockers_collision() -> void:
	$Rotatable/Casts/RightCast.position = Vector2.ZERO
	$Rotatable/Casts/LeftCast.position = Vector2.ZERO
	collision_mask -= 128
	
func enable_slide_area_blockers_collision() -> void:
	$Rotatable/Casts/RightCast.position = $Rotatable/Casts/LeftAndRightRaysNormalPos.position
	$Rotatable/Casts/LeftCast.position = $Rotatable/Casts/LeftAndRightRaysNormalPos.position
	collision_mask += 128
		
func _on_run_stop_timer_timeout() -> void: # $Timers/RunStopTimer
	if !is_running:
		
		$Timers/SlideTimer.start()

func _on_first_jump_state_timer_timeout() -> void:
	is_jump_to_fall_transition = true
	if (can_jump == true or Input.is_action_pressed("JUMP" + get_player_index()) ):# and (last_floor_angle < PI/2):
		$Timers/SecondJumpStateTimer.start()
		
func _on_second_jump_state_timer_timeout():
	is_jump_to_fall_transition = true

func _on_bump_timer_timeout() -> void:
	if is_on_floor():
		state = sm.GROUND
	else:
		state = sm.AIR

func _on_grind_area_body_entered(body):
	if body is GrindPipe:
		is_on_grind_pipe = true

func _on_grind_area_body_exited(body):
	if body is GrindPipe:
		is_on_grind_pipe = false
		
func default_velocity() -> void:
	y_vel = Vector2.ZERO
	x_vel = Vector2.ZERO
	velocity = Vector2.ZERO
		
func properties_update() -> void:
	state = sm.GROUND
	speed = NORMAL_SPEED
	last_x_vel_y = 0.0
	last_floor_angle = 0.0
	last_real_floor_angle = 0.0
	last_wall_angle = 0.0
	last_real_wall_angle = 0.0
	last_floor_normal = Vector2.ZERO
	last_wall_normal = Vector2.ZERO
	x_vel = Vector2.ZERO
	y_vel = Vector2.ZERO

	is_running = false
	is_running_fast = false
	is_attacking = false
	is_dead = false
	is_bumping = false
	is_sliding = false
	is_releasing = false
	is_jumping = false
	is_axis_changing_delayed = false
	is_on_grind_pipe = false
	is_grinding = false
	can_jump = true
		
# test

func character_swapped_indicator():
	if character_index == characters_IDs.BOY:
		$Sprite.self_modulate = Color(1, 1, 1, 1)
	else:
		$Sprite.self_modulate = Color(1, 0, 0, 1)
		
func emit_players_rebound_max_height_reached():
	g.players_rebound_max_height_reached.emit()
	
func input_is_run_and_direction_pressed() -> bool:
	if Input.is_action_pressed("RUN" + get_player_index()) and Input.get_axis("LEFT" + get_player_index(), "RIGHT" + get_player_index()) != 0:
		return true
	else:
		return false

func _on_turning_timer_timeout():
	pass
		
func _on_slide_dash_timer_timeout():
	is_sliding = false

func _on_entity_component_system_area_entered(area):
	pass
	#if area is Checkpoint:
		#last_save_point_position = area.global_position
		#area.set_deferred("monitorable", false)
		#print("checkpoint" + " " + str(last_save_point_position))

func _on_injured():
	component_system.hit_points -= 1
	if component_system.hit_points <= 0:
		#position = last_checkpoint_position
		g.death_counter += 1
		#state = sm.GHOST
		properties_update()

func _on_attack_timer_timeout():
	#$Rotatable/AttackAreas/AttackArea/Shape.disabled = true
	$Rotatable/AttackAreas/AttackArea.monitoring = false
	$Rotatable/AttackAreas/AttackArea/CollisionShape.debug_color = Color(1, 0, 0, 0)

func _on_crushing_area_area_entered(area):
	if (area.name == "CrushArea") and (area.get_parent().is_killed == false) and (velocity.y > -250):
		area.get_parent().injured.emit()
		state = sm.AIR
		if is_on_floor():
			$Timers/FloorStickBlockingTimer.start()
		y_vel.y = -1500
		
func _on_background_level_changed(new_bg_level : int) -> void:
	if new_bg_level == 1:
		#global_position = $"../../Other/ParallaxBackground/ParallaxLayer/LevelParts/Polygon2D".global_position
		global_position = Vector2(800, -1000)
		g.current_bg_zoom = Vector2(2, 2)
		reparent($"../../Other/ParallaxBackground/ParallaxLayer/Players")
		#scale = Vector2(0.5, 0.5)
		scale = Vector2.ONE
	if new_bg_level == 0:
		global_position = $"../../../../Polygon2D".global_position
		g.current_bg_zoom = Vector2.ONE
		reparent($"../../../../../Players")
		scale = Vector2.ONE
