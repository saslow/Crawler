extends Node

var gamemode : gamemodes = gamemodes.SINGLE

enum gamemodes {
	SINGLE = 0,
	COOP = 1,
	PEER_COOP = 2
}

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
const HALF_DEFAULT_RESOLUTION_HEIGHT : int = 540
const ONE_WAY_SOLIDS_LAYER : int = 9

signal player_respawned()
signal background_level_changed(new_bg_level : int)
signal players_rebound_max_height_reached()
signal lose()
signal escape_sequence_started()
signal times_up()

var is_escape : bool = false

var death_counter : int = 0 :
	set(value):
		death_counter = value
		match gamemode:
			gamemodes.SINGLE:
				if death_counter > 0:
					lose.emit()
			_:
				if death_counter > 1:
					lose.emit()

var last_player_target_rebound_position : Vector2 = Vector2.ZERO
var last_player_target_to : Layer2D

var last_checkpoint : Vector2
var last_checpoint_depth : float
var checkpointed_layer : Layer2D
var last_general_checkpoint : Vector2
var last_general_checpoint_depth : float
var general_checkpointed_layer : Layer2D

var layers_relocating : bool = false

func _ready() -> void:
	times_up.connect(_on_times_up)
	
func _on_times_up() -> void:
	escape_sequence_started.emit() # ИЗМЕНИТЬ ПОТОМ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func change_players_layer(reparent_to : Layer2D) -> void:
	#g.player.call_deferred("reparent", reparent_to.get_node("Players"))
	#g.second_player.call_deferred("reparent", reparent_to.get_node("Players"))
	g.player.reparent(reparent_to.get_node("Players"))
	#g.second_player.reparent(reparent_to.get_node("Players"))
	
func get_viewports_folder() -> Node:
	return get_node("/root/Level3D/Viewports")

func _on_player_injured():
	pass # Replace with function body.

func _on_lose():
	call_deferred("change_players_layer", checkpointed_layer)
	player.set_deferred("global_position", last_checkpoint)
