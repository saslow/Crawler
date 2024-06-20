extends PathFollow2D

@export var behaviour : behaviours = behaviours.STATIC
#@export var path : Path2D

@export var speed : float = 1000

@export var negate_speed : bool = false

var start_progress : float

enum behaviours{
	STATIC = 0,
	WANDERING_LOOP = 1,
	WANDERING_VARIABLE = 2,
}

func _ready():
	#g.player_respawned.connect(_on_player_respawned)
	start_progress = progress

func _physics_process(delta):
	match behaviour:
		behaviours.WANDERING_LOOP:
			if negate_speed:
				progress -= delta * speed
			else:
				progress += delta * speed
		behaviours.WANDERING_VARIABLE:
			if progress_ratio == 0:
				negate_speed = false
				progress_ratio == 0.01
			elif progress_ratio == 1:
				negate_speed = true
				progress_ratio == 0.99
			if negate_speed:
				progress -= delta * speed
			else:
				progress += delta * speed
				
func _on_player_respawned():
	progress = start_progress
