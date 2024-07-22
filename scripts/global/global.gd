extends Node

var current_level : Level3D
var current_layer : Layer2D
var player : Player
var second_player : Player
#@onready var player_second : Player
#var player_input_swapped : bool = false : set = _set_player_input_swap
#var player_character_swapped : bool = false : set = _set_player_character_swapped
var current_character : Player
var another_character : Player
const GRAVITY = 60
const MAX_FALLING_VEL_Y : int = 5000
const MIN_FALLING_VEL_Y : int = -60000
const DEFAULT_RESOLUTION : Vector2 = Vector2(1920, 1080)

signal player_respawned()
signal background_level_changed(new_bg_level : int)

func change_players_layer(reparent_to : Layer2D) -> void:
	g.player.reparent(reparent_to.get_node("Players"))
	g.second_player.reparent(reparent_to.get_node("Players"))
	
func get_viewports_folder() -> Node:
	return get_node("/root/Level3D/Viewports")
