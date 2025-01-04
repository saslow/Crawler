@icon("res://addons/rmsmartshape/assets/icon_editor_handle_bezier.svg")
extends Node2D
class_name Room


var player_current_layer_id : int = 0
var bg_holder : CanvasLayer
#var ui : CanvasLayer

var closest_layer_z : float = 64.0

func _ready() -> void:
	pass
	#if !Engine.is_editor_hint():
		#bg_holder = $BGHolder
		#ui = $UI
	
		#g.current_level = self
	if get_child_count() != 0:
		for i : Layer2D in get_children():
			if i.z < closest_layer_z:
				closest_layer_z = i.z
				#var svp_holder : SubViewportContainer = SubViewportContainer.new()
				#var svp : SubViewport = SubViewport.new()
				#set_svp_custom_properties(svp, i.transparent, g.DEFAULT_RESOLUTION, "SVP" + str(i.get_index()))
				#$Viewports.add_child(svp_holder)
				#svp_holder.add_child(svp)
				#var h : Sprite2D = Sprite2D.new()
				#h.scale = Vector2(i.z, i.z)
				#h.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
				#$Layers3D.add_child(h)
				#
				#i.call_deferred("reparent", svp)

#func set_svp_custom_properties(svp : SubViewport, transparent : bool, size : Vector2, _name : String) -> void:
	#svp.name = _name
	#svp.size = size
	#svp.disable_3d = true
	#svp.audio_listener_enable_2d = true
	#svp.transparent_bg = transparent
	#svp.positional_shadow_atlas_size = 0
	#svp.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED
	#svp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	#svp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
