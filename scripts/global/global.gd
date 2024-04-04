extends Node

@onready var current_level : Level = get_tree().current_scene
@onready var player_first : Player = current_level.get_player(0)
@onready var player_second : Player = current_level.get_player(1)
var player_input_swapped : bool = false : set = _set_player_input_swap
var player_character_swapped : bool = false : set = _set_player_character_swapped
var current_character : Player
var another_character : Player

func _ready():
	current_character = player_first
	another_character = player_second
	
#const MAX_RUN_WALL_ANGLE : float = PI / 1.4
const GRAVITY = 60

func _physics_process(delta):
	if Input.is_action_just_pressed("PLAYER_INPUT_SWAP") and player_first.global_position.distance_to(player_second.global_position) < 1000:
		player_input_swapped = !player_input_swapped
	if Input.is_action_just_pressed("SWAP"):
		player_character_swapped = !player_character_swapped
	
func _set_player_input_swap(value : bool) -> void:
	if value == false:
		player_first.player_index = Player.player_IDs.FIRST
		player_second.player_index = Player.player_IDs.SECOND
		#player_first.get_camera().set_follow_target_node(player_first)
		current_character = player_first
		another_character = player_second
	else:
		player_first.player_index = Player.player_IDs.SECOND
		player_second.player_index = Player.player_IDs.FIRST
		#player_first.get_camera().set_follow_target_node(player_second)
		current_character = player_second
		another_character = player_first
	player_input_swapped = value

func _set_player_character_swapped(value : bool) -> void:
	if value == false:
		player_first.character_index = Player.characters_IDs.BOY
		player_second.character_index = Player.characters_IDs.GIRL
	else:
		player_first.character_index = Player.characters_IDs.GIRL
		player_second.character_index = Player.characters_IDs.BOY
	player_character_swapped = value
