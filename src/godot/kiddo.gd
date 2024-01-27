extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var configPath : NodePath
export var cameraPath : NodePath
export var statePath : NodePath
 
var colors : Array = []
var camera : Camera2D = null
var stroke_width = 10

var emotion_happycry = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	colors = get_node(configPath).colors
	stroke_width = get_node(configPath).stroke_width
	camera = get_node(cameraPath)
	camera.make_current()
	
	camera.zoom = Vector2(1.25, 1.25)
	
	var state = get_node(statePath).connect("emotion_update", self, "emotion_update_handler")

func emotion_update_handler(p_emotion_happycry):
	emotion_happycry = p_emotion_happycry
	
func _process(delta):
	update()

func _draw():
	var head_radius = 600*0.5
	
	draw_body(head_radius)
	draw_head(head_radius)
	draw_mouth(head_radius)
	draw_nose(head_radius)
	draw_eyes(head_radius)
	draw_eyebrows(head_radius)
	
func draw_body(head_radius):
	var body = get_body(head_radius)
	draw_colored_polygon(body, colors[0])
	draw_polyline(body, colors[1], stroke_width, true)
	
func get_body(head_radius):
	var neck_angle = PI/3.0
	var shoulder_angle = PI/6.0
	var origin = Vector2.ZERO
	
	var left_top_neck = origin + Vector2(cos(PI+neck_angle), -sin(PI+neck_angle))*head_radius
	var left_bottom_neck = left_top_neck + Vector2(0, head_radius*0.1)
	var left_extreme = left_bottom_neck + Vector2(cos(PI+shoulder_angle), -sin(PI+shoulder_angle))*head_radius
	
	var right_top_neck = origin + Vector2(cos(-neck_angle), -sin(-neck_angle))*head_radius
	var right_bottom_neck = right_top_neck + Vector2(0, head_radius*0.1)
	var right_extreme = right_bottom_neck + Vector2(cos(-shoulder_angle), -sin(-shoulder_angle))*head_radius
	
	return [
		left_top_neck,
		left_bottom_neck,
		left_extreme,
		right_extreme,
		right_bottom_neck,
		right_top_neck,
	]
	
func draw_head(head_radius):
	draw_circle(Vector2.ZERO, head_radius, colors[0])
	draw_arc(Vector2.ZERO, head_radius, 0, 2*PI, 50, colors[1], stroke_width, true)
	
func draw_mouth(head_radius):
	var mouth_angle = PI/4.0
	var mouth_radius_factor = 0.4
	var mouth_middle_left = Vector2(cos(PI+mouth_angle), -sin(PI+mouth_angle)) * head_radius * mouth_radius_factor
	var mouth_middle_right = Vector2(cos(-mouth_angle), -sin(-mouth_angle)) * head_radius * mouth_radius_factor
	var mouth_top_left = mouth_middle_left - Vector2(0, head_radius * 0.4)
	var mouth_top_right = mouth_middle_right - Vector2(0, head_radius * 0.4)
	var mouth_bottom_left = mouth_middle_left + Vector2(0, head_radius * 0.4)
	var mouth_bottom_right = mouth_middle_right + Vector2(0, head_radius * 0.4)
	
	if (emotion_happycry >= 0):
		var t = min(emotion_happycry, 0.5)
		var m_topleft = mouth_middle_left.linear_interpolate(mouth_top_left, t)
		var m_middle = mouth_middle_left.linear_interpolate(mouth_middle_right, 0.5)
		var m_topright = mouth_middle_right.linear_interpolate(mouth_top_right, t)
		
		var c = Curve2D.new()
		c.add_point(m_topleft, Vector2.ZERO, Vector2(0, m_middle.y - m_topleft.y)*0.5)
		c.add_point(m_middle, Vector2(m_topleft.x - m_middle.x, 0)*0.5, Vector2(m_topright.x - m_middle.x, 0)*0.5)
		c.add_point(m_topright, Vector2(0,  m_middle.y - m_topright.y)*0.5, Vector2.ZERO)
		
		var points = c.get_baked_points()
		if (emotion_happycry >= 0.5):
			var n_points = points.size()
			var remove_n = max(min(floor((n_points / 2) - ((emotion_happycry-0.5)/0.5)*(n_points/2)), (n_points/2)-5), 0)
			var arr = Array(points)
			var p = arr.slice(remove_n, points.size() - remove_n)
			p.append(p[0])
			draw_colored_polygon(p, colors[1])
			draw_polyline(p, colors[1], stroke_width, true)
		
		draw_polyline(points, colors[1], stroke_width, true)
			
	elif (emotion_happycry < 0):
		var t = min(abs(emotion_happycry), 0.5)
		var m_bottomleft = mouth_middle_left.linear_interpolate(mouth_bottom_left, t)
		var m_middle = mouth_middle_left.linear_interpolate(mouth_middle_right, 0.5)
		var m_bottomright = mouth_middle_right.linear_interpolate(mouth_bottom_right, t)
		
		var c = Curve2D.new()
		c.add_point(m_bottomleft, Vector2.ZERO, Vector2(0, m_middle.y - m_bottomleft.y)*0.5)
		c.add_point(m_middle, Vector2(m_bottomleft.x - m_middle.x, 0)*0.5, Vector2(m_bottomright.x - m_middle.x, 0)*0.5)
		c.add_point(m_bottomright, Vector2(0,  m_middle.y - m_bottomright.y)*0.5, Vector2.ZERO)
		
		var points = c.get_baked_points()
		
		if (emotion_happycry < -0.5):
			var abs_emotion_happycry = abs(emotion_happycry)
			var n_points = points.size()
			var remove_n = max(min(floor((n_points / 2) - ((abs_emotion_happycry-0.5)/0.5)*(n_points/2)), (n_points/2)-5), 0)
			var arr = Array(points)
			var p = arr.slice(remove_n, points.size() - remove_n)
			p.append(p[0])
			draw_colored_polygon(p, colors[1])
			draw_polyline(p, colors[1], stroke_width, true)
			
		draw_polyline(points, colors[1], stroke_width, true)
		
func draw_nose(head_radius):
	draw_circle(Vector2(-head_radius*0.03, 0), head_radius*0.02, colors[1])
	draw_circle(Vector2(head_radius*0.03, 0), head_radius*0.02, colors[1])
	
func draw_eyes(head_radius):
	pass
	
func draw_eyebrows(head_radius):
	pass
