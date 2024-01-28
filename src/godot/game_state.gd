extends Node


# emotion and shape are 

# this value is 1.0 when baby is absolutely happy, -1.0 when baby is desperately crying
export var emotion_happycry : float = 0

export var shape_friendlyscary : float = 0

export var left_hand_cover : float = 0
export var right_hand_cover : float = 0

export var label_text : NodePath
var label_node : Label

var shape_noise = OpenSimplexNoise.new()
var timer = 0

signal emotion_update(happycry)
signal shapeshifter_update(friendlyscary)

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
	clamp(emotion_happycry, -1, 1)
	shape_friendlyscary = shape_noise.get_noise_1d(timer)
	
	label_node.text = "happycry: %s\nshape_friendlyscary: %s" % [emotion_happycry, shape_friendlyscary]
	
	emit_signal("emotion_update", emotion_happycry)
	emit_signal("shapeshifter_update", shape_friendlyscary)

