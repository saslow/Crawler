extends Node2D

@export var state : sm = sm.IDLE
@export_range(-1, 1, 2) var direction : int = -1
@onready var b : Enemy = $EnemyTemplate
var player_is_in_area : bool = false
@export var can_move : bool = false
var is_angry : bool = false

enum sm{
	IDLE = 0,
	AIR = 1,
	WALKING = 2,
	ANGER = 3,
}

var start_direction : int

# Called when the node enters the scene tree for the first time.
func _ready():
	start_direction = direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	falling()
	
	if is_angry:
		$EnemyTemplate/Rotatable/PlayerDetectingArea.scale.x = 2
	else:
		$EnemyTemplate/Rotatable/PlayerDetectingArea.scale.x = 1.25
	
	rotatable_leveling()
	
	if b.is_killed:
		$EnemyTemplate/Rotatable/AttackHitbox.set_deferred("monitoring", false)
		player_is_in_area = false
	
	if $Anim.current_animation != "attack":
		if g.player.global_position.x > b.global_position.x:
			direction = 1
			$EnemyTemplate/Sprite.scale.x = 2
			$EnemyTemplate/CrushArea.scale.x = 1
			$EnemyTemplate/Rotatable/AttackHitbox.scale.x = 1
		if g.player.global_position.x < b.global_position.x:
			direction = -1
			$EnemyTemplate/Sprite.scale.x = -2
			$EnemyTemplate/CrushArea.scale.x = -1
			$EnemyTemplate/Rotatable/AttackHitbox.scale.x = -1
		
	if player_is_in_area and $Cooldown.is_stopped():
		$Anim.play("attack")
	elif $Anim.current_animation != "attack":
		if !can_move:
			idle()
		$Anim.play("idle")
	if can_move:
		move()
	
	b.move_and_slide()
#
#func floor_attaching() -> void:
	#if b.is_on_floor():
		#state = sm.IDLE

#func floor_detaching() -> void:
	#if not(b.is_on_floor()):
		#state = sm.AIR

func move() -> void:
	b.velocity.x = lerpf(b.velocity.x, direction * 1200, 0.1)
	
func idle() -> void:
	b.velocity.x = lerpf(b.velocity.x, 0, 0.2)

func falling() -> void:
	b.velocity.y += g.GRAVITY
	b.velocity.y = clampf(b.velocity.y, g.MIN_FALLING_VEL_Y, g.MAX_FALLING_VEL_Y)

func _on_player_respawned() -> void:
	$EnemyTemplate/Rotatable/AttackHitbox.set_deferred("monitoring", false)
	is_angry = false
	$Anim.play("idle")
	player_is_in_area = false
	b.velocity = Vector2.ZERO
	state = sm.IDLE
	direction = start_direction
	
func rotatable_leveling() -> void:
	$EnemyTemplate/Rotatable.rotation = get_real_floor_angle()
	
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

func _on_player_detecting_area_body_entered(body):
	if body is Player:
		is_angry = true
		player_is_in_area = true
	
func _on_player_detecting_area_body_exited(body):
	if body is Player:
		is_angry = false
		player_is_in_area = false
	
