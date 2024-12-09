extends Node2D

@onready var p : Enemy = get_parent()
const SPEED : int = 15000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if p.progress_ratio == 0:
		p.progress_ratio = 0.01
		$TurningTimer.start()
		$Anim.play("prepare")
	if p.progress_ratio == 1:
		p.progress_ratio = 0.99
		$TurningTimer.start()
		$Anim.play("prepare")
	if $TurningTimer.is_stopped():
		$Anim.play("walk")
		#move()

func play_anim_attack() -> void:
	$Anim.play("attack")

func move() -> void:
	print(p.direction)
	p.progress += SPEED * get_physics_process_delta_time() * p.direction
	
func step() -> void:
	p.progress = lerp(p.progress, p.progress + (SPEED * get_physics_process_delta_time() * p.direction), 0.1)

func _on_turning_timer_timeout():
	p.turn()
