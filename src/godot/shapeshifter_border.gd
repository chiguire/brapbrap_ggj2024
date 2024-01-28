extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_path : NodePath
export var config_path : NodePath
export var state_path : NodePath

var shapeshifter_friendlyscary : float
var colors : Array = []
var stroke_width : float = 0
var camera : Camera2D

var left_hand_cover : float
var right_hand_cover : float

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(camera_path)
	colors = get_node(config_path).colors
	stroke_width = get_node(config_path).stroke_width
	get_node(state_path).connect("shapeshifter_update", self, "shapeshifter_update_handler")
	get_node(state_path).connect("hands_update", self, "hands_update_handler")

func shapeshifter_update_handler(p_shapeshifter_friendlyscary):
	shapeshifter_friendlyscary = p_shapeshifter_friendlyscary

func hands_update_handler(p_left_hand_cover, p_right_hand_cover):
	left_hand_cover = p_left_hand_cover
	right_hand_cover = p_right_hand_cover
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()
	
func _draw():
	var size = camera.get_viewport().size*camera.zoom
	var pos = Vector2(0, 0)
	
	var p = []
	var t = clamp(shapeshifter_friendlyscary * 0.5 + 0.5, 0, 1.0)
	
	p.append(pos + Vector2(-size.x, -size.y)*0.5)
	var n_segments = 5
	for i in range(n_segments):
		p.append(pos + Vector2(-size.x, -size.y)*0.5 + Vector2(size.x*i/n_segments, 0))
	p.append(pos + Vector2( size.x, -size.y)*0.5)
	for i in range(n_segments):
		p.append(pos + Vector2(size.x, -size.y)*0.5 + Vector2(0, size.y*i/n_segments))
	p.append(pos + Vector2( size.x, size.y)*0.5)
	for i in range(n_segments):
		p.append(pos + Vector2(size.x, size.y)*0.5 + Vector2(-size.x*i/n_segments, 0))
	p.append(pos + Vector2(-size.x, size.y)*0.5)
	for i in range(n_segments):
		p.append(pos + Vector2(-size.x, size.y)*0.5 + Vector2(0, -size.y*i/n_segments))
	
	#draw_border(Vector2.ZERO, size.y/3, t)
	for i in p:
		draw_border(i, size.y/3, t)
		
	draw_hands(Vector2(pos.x, size.y*0.5))
	
func draw_border(center, size, t):
	var top = center + Vector2(0, -size)*0.5
	var right = center + Vector2(size, 0)*0.5
	var bottom = center + Vector2(0, size)*0.5
	var left = center + Vector2(-size, 0)* 0.5
	
	var max_angle = PI/6.0
	var top_in = (Vector2(-1, 1)*size*0.2).rotated(lerp(-max_angle, max_angle, t))
	var top_out = (Vector2(1, 1)*size*0.2).rotated(lerp(max_angle, -max_angle, t))
	var right_in = (Vector2(-1, -1)*size*0.2).rotated(lerp(-max_angle, max_angle, t))
	var right_out = (Vector2(-1, 1)*size*0.2).rotated(lerp(max_angle, -max_angle, t))
	var bottom_in = (Vector2(1, -1)*size*0.2).rotated(lerp(-max_angle, max_angle, t))
	var bottom_out = (Vector2(-1, -1)*size*0.2).rotated(lerp(max_angle, -max_angle, t))
	var left_in = (Vector2(1, 1)*size*0.2).rotated(lerp(-max_angle, max_angle, t))
	var left_out = (Vector2(1, -1)*size*0.2).rotated(lerp(max_angle, -max_angle, t))
	
	var c = Curve2D.new()
	c.add_point(top, Vector2.ZERO, top_out)
	c.add_point(right, right_in, right_out)
	c.add_point(bottom, bottom_in, bottom_out)
	c.add_point(left, left_in, left_out)
	c.add_point(top, top_in, Vector2.ZERO)
	
	var points = c.get_baked_points()

	draw_colored_polygon(points, colors[2].linear_interpolate(colors[3], t))

func draw_hands(center):
	var hand_distance = 150
	var uncover_hand_distance = 250
	
	draw_left_hand(center - Vector2(lerp(hand_distance, uncover_hand_distance, 1.0-left_hand_cover), 0))
	draw_right_hand(center + Vector2(lerp(hand_distance, uncover_hand_distance, 1.0-right_hand_cover), 0))

func draw_left_hand(center):
	var hand_size = Vector2(240, 100)
	draw_rect(Rect2(center - hand_size*0.5, hand_size), colors[0], true)
	draw_rect(Rect2(center - hand_size*0.5, hand_size), colors[1], false, stroke_width)
	for i in range(1,4):
		var finger_distance = hand_size.x / 4
		var x = center.x - hand_size.x*0.5 + i*finger_distance
		var y0 = center.y - hand_size.y * 0.5
		var y1 = center.y + hand_size.y * 0.5
		draw_line(Vector2(x, y0), Vector2(x, y1), colors[1], stroke_width, true)
	
func draw_right_hand(center):
	var hand_size = Vector2(240, 100)
	draw_rect(Rect2(center - hand_size*0.5, hand_size), colors[0], true)
	draw_rect(Rect2(center - hand_size*0.5, hand_size), colors[1], false, stroke_width)
	for i in range(1,4):
		var finger_distance = hand_size.x / 4
		var x = center.x - hand_size.x*0.5 + i*finger_distance
		var y0 = center.y - hand_size.y * 0.5
		var y1 = center.y + hand_size.y * 0.5
		draw_line(Vector2(x, y0), Vector2(x, y1), colors[1], stroke_width, true)
	
