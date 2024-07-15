extends Node

var current_level : Level = null
var player : Player = null
var second_player : Player = null
#@onready var player_second : Player = null
#var player_input_swapped : bool = false : set = _set_player_input_swap
#var player_character_swapped : bool = false : set = _set_player_character_swapped
var current_character : Player
var another_character : Player
const GRAVITY = 60
const MAX_FALLING_VEL_Y : int = 5000
const MIN_FALLING_VEL_Y : int = -60000
var current_bg_zoom : Vector2 = Vector2.ONE
var current_bg_level : int = 0

signal player_respawned()
signal background_level_changed(new_bg_level : int)
