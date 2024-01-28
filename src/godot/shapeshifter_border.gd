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
	

