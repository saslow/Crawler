@tool
extends Label

@export var enabled : bool = true

func _ready():
	if !Engine.is_editor_hint():
		queue_free()
	else:
		if enabled:
			text = get_parent().name

var lastZoom : float = 0.0
var vp : Viewport = null

func _process(delta):
	if Engine.is_editor_hint():
		text = get_parent().name
		var newZoom
		if vp == null:
			vp = get_viewport()
			#print("zoom getter vp set")
		newZoom = vp.get_final_transform().x.x
		
		if lastZoom != newZoom:
			#print( "%f" % newZoom )
			#print("%f" % newZoom)
			lastZoom = newZoom
			resize_gizmo()

func resize_gizmo() -> void:
	if enabled:
		if lastZoom <= 1:
			scale = Vector2.ONE * (1 + (1 - lastZoom )) ** 3
		else:
			scale = Vector2.ONE
