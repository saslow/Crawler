@tool
extends Node3D
class_name Level3D

#@export var _relocate_layers : bool = false :
	#set(value):
		#_relocate_layers = false
var player_current_layer_id : int = 0
const SVP_HOLDER_PIXEL_SIZE : float = 0.0083
@onready var mc : Camera3D = $MainCamera
var is_mc_transitioning : bool
var target_transition_z : float
const DEFAULT_MC_TRANSITION_TIME : float = 2.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Engine.is_editor_hint():
		g.current_level = self
		if $Layers2D.get_child_count() != 0:
			for i : Layer2D in $Layers2D.get_children():
				var svp : SubViewport = SubViewport.new()
				set_svp_custom_properties(svp, i.transparent, g.DEFAULT_RESOLUTION * i.z, "SVP" + str(i.get_index()))
				$Viewports.add_child(svp)
				var h : Sprite3D = Sprite3D.new()
				set_svp_holder_custom_properties(h, svp, i.z, i.name)
				
				$Layers3D.add_child(h)
				
				i.reparent(svp)
				
func _physics_process(delta) -> void:
	mc_transitioning_process()

func set_svp_custom_properties(svp : SubViewport, transparent : bool, size : Vector2, name : String) -> void:
	svp.name = name
	svp.size = size
	svp.disable_3d = true
	svp.audio_listener_enable_2d = true
	svp.transparent_bg = transparent
	svp.positional_shadow_atlas_size = 0
	svp.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED
	svp.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	
func set_svp_holder_custom_properties(h : Sprite3D, svp : SubViewport, z : float, name : String) -> void:
	h.double_sided = false
	h.no_depth_test = true
	h.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	h.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
	h.gi_mode = GeometryInstance3D.GI_MODE_DISABLED
	h.position.z = -z * 13
	h.name = name
	#var texture : ViewportTexture = ViewportTexture.new()
	#texture.viewport_path = get_path_to(svp)
	#h.texture = texture
	h.texture = svp.get_texture()
	
func mc_transitioning_process():
	if is_mc_transitioning:
		mc.position.z = lerpf(mc.position.z, target_transition_z, 0.1)

func start_mc_transition(to_z : float, time : float = DEFAULT_MC_TRANSITION_TIME) -> void:
	is_mc_transitioning = true
	target_transition_z = -((to_z - 1) * 13)
	await get_tree().create_timer(time).timeout
	is_mc_transitioning = false
