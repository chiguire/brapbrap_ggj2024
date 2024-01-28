extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_path : NodePath
export var config_path : NodePath
export var state_path : NodePath

var colors : Array = []
var emotion_happycry : float = 0
var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(camera_path)
	colors = get_node(config_path).colors
	get_node(state_path).connect("emotion_update", self, "emotion_update_handler")

func emotion_update_handler(p_emotion_happycry):
	emotion_happycry = p_emotion_happycry

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	var transf = camera.get_viewport().get_canvas_transform().affine_inverse()
	var pos = transf * Vector2.ZERO
	var size = transf * camera.get_viewport().size * 2
	
	var c : Color = colors[2].linear_interpolate(colors[3], emotion_happycry*0.5+0.5)
	draw_rect(Rect2(pos, size), c.darkened(0.5), true)
