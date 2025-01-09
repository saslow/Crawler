extends Node2D
class_name Level2D

var ui : CanvasLayer
@export var starting_room : Room
@onready var current_room : Room = starting_room

@export_category("Escape Timer")
@export var mins : int = 1
@export var secs : int = 0

func _ready():
	if !Engine.is_editor_hint():
		g.current_level = self
		ui = $UI
		create_tree()
		change_room_to(starting_room)
	
func create_tree() -> void:
	#if get_node("Holders") == null:
		#var hs : Node2D = Node2D.new()
		#hs.name = "Holders"
		#add_child(hs, true)
	if get_node("Viewports") == null:
		var vs : Node2D = Node2D.new()
		vs.name = "Viewports"
		add_child(vs, true)
	if get_node("Rooms") == null:
		var rs : Node2D = Node2D.new()
		rs.name = "Rooms"
		add_child(rs, true)


func translate_room_to_viewports(from_room : Room) -> void:
	await RenderingServer.frame_post_draw

	for layer : Layer2D in from_room.get_children():
		if layer is Layer2D:
			var svpc : SubViewportContainer = SubViewportContainer.new()
			var svp : SubViewport = SubViewport.new()
			set_svp_custom_properties(svp, g.DEFAULT_RESOLUTION, layer.transparent)
			get_node("Viewports").add_child(svpc)
			svpc.call_deferred("add_child", svp)
			layer.call_deferred("reparent", svp)
	print_debug("Room translated to viewports " + from_room.name + " " + str(from_room) + " " + str(from_room.get_path()))
					
func translate_viewports_to_room(to_room : Room) -> void:
	for svpc : SubViewportContainer in get_node("Viewports").get_children():
		if svpc is SubViewportContainer:
			var svp : SubViewport = svpc.get_child(0)
			var layer : Layer2D = svp.get_child(0)
			layer.call_deferred("reparent", to_room)
			svpc.queue_free()
	print_debug("Viewports translated to room " + to_room.name + " " + str(to_room))
					
func set_svp_custom_properties(svp : SubViewport, size : Vector2, transparency : bool) -> void:
	svp.name = "SVP0" # SubViewport
	svp.size = size
	svp.disable_3d = true
	svp.audio_listener_enable_2d = true
	svp.transparent_bg = transparency
	svp.positional_shadow_atlas_size = 0
	svp.positional_shadow_atlas_16_bits = false
	svp.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED
	svp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	svp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS

func change_room_to(new : Room) -> void:
	current_room.visible = false
	translate_viewports_to_room(current_room)
	current_room = new
	translate_room_to_viewports(new)
	new.visible = true
	new.process_mode = Node.PROCESS_MODE_INHERIT
	#current_room.process_mode = Node.PROCESS_MODE_DISABLED
