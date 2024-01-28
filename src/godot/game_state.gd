extends Node


# emotion and shape are 

# this value is 1.0 when baby is absolutely happy, -1.0 when baby is desperately crying
export var emotion_happycry : float = 0

export var shape_friendlyscary : float = 0

export var left_hand_cover : float = 1.0
export var right_hand_cover : float = 1.0
export var cover_threshold : float = 0.5

export var leap_motion_path : NodePath
#var leap_motion : GDLMSensor

export var label_text : NodePath
var label_node : Label

var shape_noise = OpenSimplexNoise.new()
var timer = 0
var uncover_timer : float = 0

var time_laughed : float = 0
var time_cried : float = 0
export var laugh_timer_label_path : NodePath
var laugh_timer_label : Label

signal emotion_update(happycry)
signal shapeshifter_update(friendlyscary)
signal baby_looked_at(enabled)
signal hands_update(left_hand_cover, right_hand_cover)

# Called when the node enters the scene tree for the first time.
func _ready():
	shape_noise.seed = randi()
	shape_noise.octaves = 2
	shape_noise.period = 1.0
	shape_noise.persistence = 0.2
	label_node = get_node(label_text)
	label_node.visible = false
	
	laugh_timer_label = get_node(laugh_timer_label_path)
	#leap_motion = get_node(leap_motion_path)
	startGame()

func startGame():
	timer = 0
	emotion_happycry = 0 + randf()*0.1
	shape_friendlyscary = shape_noise.get_noise_1d(timer)
	left_hand_cover = 1.0
	right_hand_cover = 1.0
	
func _process(delta):
	timer += delta*0.3
	emotion_happycry = clamp(emotion_happycry, -1, 1)
	
	if (Input.is_action_pressed("ui_accept")):
		left_hand_cover = 0.0
		right_hand_cover = 0.0
		uncover_timer += delta
	else:
		left_hand_cover = 1.0
		right_hand_cover = 1.0
		uncover_timer = 0
		shape_friendlyscary = shape_noise.get_noise_1d(timer)*2
		emotion_happycry = emotion_happycry * 0.998
		
	var baby_looked = false
	if (left_hand_cover <= cover_threshold):
		interact_with_kiddo()
		baby_looked = true
	
	if (emotion_happycry > 0.5):
		time_laughed += delta
		
	if (emotion_happycry < -0.5):
		time_cried += delta
	
	label_node.text = "happycry: %s\nshape_friendlyscary: %s\ncover: (%s, %s)" % [emotion_happycry, shape_friendlyscary, left_hand_cover, right_hand_cover]
	laugh_timer_label.text = "Time Laughing: %.2f\nTime Crying: %.2f" % [time_laughed, time_cried]
	
	emit_signal("emotion_update", emotion_happycry)
	emit_signal("shapeshifter_update", shape_friendlyscary)
	emit_signal("baby_looked_at", baby_looked)
	emit_signal("hands_update", left_hand_cover, right_hand_cover)

func interact_with_kiddo():
	var e = Vector2(emotion_happycry, 0)
	var s = Vector2(shape_friendlyscary, 0)
	emotion_happycry = e.move_toward(s, uncover_timer*0.02).x
