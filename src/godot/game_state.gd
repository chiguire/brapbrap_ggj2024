extends Node


# emotion and shape are 

export var emotion_happycry : float = 0

export var shape_friendlyscary : float = 0

export var left_hand_cover : float = 0
export var right_hand_cover : float = 0

export var label_text : NodePath
var label_node : Label

var shape_noise = OpenSimplexNoise.new()
var timer = 0

signal emotion_update(happycry)

# Called when the node enters the scene tree for the first time.
func _ready():
	shape_noise.seed = randi()
	shape_noise.octaves = 4
	shape_noise.period = 20.0
	shape_noise.persistence = 0.8
	label_node = get_node(label_text)

func startGame():
	timer = 0
	shape_friendlyscary = shape_noise.get_noise_1d(timer)

func _process(delta):
	timer += delta*0.3
	shape_friendlyscary = shape_noise.get_noise_1d(timer)
	
	emotion_happycry = sin(timer*2-1.0)
	label_node.text = "%s" % emotion_happycry
	
	if (emotion_happycry > 0):
		VisualServer.set_default_clear_color(Color.red)
	else:
		VisualServer.set_default_clear_color(Color.purple)
	
	emit_signal("emotion_update", emotion_happycry)
