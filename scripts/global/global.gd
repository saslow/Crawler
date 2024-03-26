extends Node

@onready var current_level : Level = get_tree().current_scene
@onready var player : CharacterBody2D = current_level.get_player()

#const MAX_RUN_WALL_ANGLE : float = PI / 1.4
const GRAVITY = 60

