extends Node

@onready var current_level : Level = null
@onready var player : Player = null
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

#func _set_player_input_swap(value : bool) -> void:
	#if value == false:
		#player_first.player_index = Player.player_IDs.FIRST
		#player_second.player_index = Player.player_IDs.SECOND
		##player_first.get_camera().set_follow_target_node(player_first)
		#current_character = player_first
		#another_character = player_second
	#else:
		#player_first.player_index = Player.player_IDs.SECOND
		#player_second.player_index = Player.player_IDs.FIRST
		##player_first.get_camera().set_follow_target_node(player_second)
		#current_character = player_second
		#another_character = player_first
	#player_input_swapped = value

#func _set_player_character_swapped(value : bool) -> void:
	#if value == false:
		#player_first.character_index = Player.characters_IDs.BOY
		#player_second.character_index = Player.characters_IDs.GIRL
	#else:
		#player_first.character_index = Player.characters_IDs.GIRL
		#player_second.character_index = Player.characters_IDs.BOY
	#player_character_swapped = value
	
func _ready():
	background_level_changed.connect(_on_background_level_changed)
	#background_level_changed.connect(_on_background_level_changed)
	#change_current_level("res://scenes/levels/level_0.tscn")
	#current_character = player_first
	#another_character = player_second
	pass

func _physics_process(delta):
	#if Input.is_action_just_pressed("PLAYER_INPUT_SWAP"):
		#player_input_swapped = !player_input_swapped
		##change_current_level("res://scenes/levels/level_1.tscn")
	#if Input.is_action_just_pressed("SWAP"):
		#player_character_swapped = !player_character_swapped
	pass
		
func change_current_level(path : String) -> void:
	get_tree().change_scene_to_file(path)
	
func _on_background_level_changed(value : int) -> void:
	current_bg_level = value
