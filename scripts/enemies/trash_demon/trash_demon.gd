extends Node2D

@onready var p : Enemy = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_anim_attack() -> void:
	$Anim.play("attack")
