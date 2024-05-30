@tool
extends Node2D

@export var tile_instance : PackedScene = load("res://scenes/level_parts/ladder/ladder_tile.tscn")
@export var spacing : float = 140
@export var real_time_line_update : bool = false

@export var _autocreate_tiles : bool = false : 
	set(value):
		var times = ($Path.curve.get_baked_length()/spacing)
		for i in range(times):
			create_tile()
		_autocreate_tiles = false
		
@export var _update_points : bool = false :
	set(value):
		update_tiles()
		update_line()
		_update_points = false

func _ready():
	_autocreate_tiles = true
	_update_points = true
	update_line()

func _process(_delta):
	if Engine.is_editor_hint():
		if real_time_line_update:
			update_line()
			
################################################################################

func update_line() -> void:
	$Line.clear_points()
	$SS2D_Shape_Open._points = null
	for tile in $Path.get_children():
		$Line.add_point(tile.position, tile.get_index())
	var new_shape_points := SS2D_Point_Array.new()
	for p: Vector2 in $Line.points:
		new_shape_points.add_point(p)
	$SS2D_Shape_Open._points = new_shape_points
	
func update_tiles() -> void:
	for tile in $Path.get_children():
		tile.progress = tile.get_index() * spacing
		
func create_tile() -> void:
	var new_tile = tile_instance.instantiate()
	$Path.add_child(new_tile)
	new_tile.set_owner($Path)
