extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_path : NodePath
export var config_path : NodePath
export var state_path : NodePath

var shapeshifter_friendlyscary : float
var colors : Array = []
var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(camera_path)
	colors = get_node(config_path).colors
	get_node(state_path).connect("shapeshifter_update", self, "shapeshifter_update_handler")

func shapeshifter_update_handler(p_shapeshifter_friendlyscary):
	shapeshifter_friendlyscary = p_shapeshifter_friendlyscary

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	delta
	
func _draw():
	var transf = camera.get_viewport().get_canvas_transform().affine_inverse()
	var size = camera.get_viewport().size*camera.zoom
	var pos = Vector2(0, 0)
	
	var p = []
	var t = shapeshifter_friendlyscary * 0.5 + 0.5
	
	p.append(pos + Vector2(-size.x, -size.y)*0.5)
	p.append(pos + Vector2( size.x, -size.y)*0.5)
	p.append(pos + Vector2( size.x, size.y)*0.5)
	p.append(pos + Vector2(-size.x, size.y)*0.5)
	
	for i in p:
		draw_border(i, size.y/3, t)
	
func draw_border(center, size, t):
	var p = []
	p.append(center + Vector2(-size, -size)*0.5)
	p.append(center + Vector2(size, -size)*0.5)
	p.append(center + Vector2(size, size)*0.5)
	p.append(center + Vector2(-size, size)*0.5)
	
	#var c = Curve2D.new()
	#c.add_point(m_bottomleft, Vector2.ZERO, Vector2(0, m_middle.y - m_bottomleft.y)*0.5)
	#c.add_point(m_middle, Vector2(m_bottomleft.x - m_middle.x, 0)*0.5, Vector2(m_bottomright.x - m_middle.x, 0)*0.5)
	#c.add_point(m_bottomright, Vector2(0,  m_middle.y - m_bottomright.y)*0.5, Vector2.ZERO)
	
	#var points = c.get_baked_points()

	draw_colored_polygon(p, colors[2].linear_interpolate(colors[3], t))
