extends Node2D

func _ready():
	g.player = get_child(0)
	g.second_player = get_child(1)
	#g.player_second = get_child(1)
