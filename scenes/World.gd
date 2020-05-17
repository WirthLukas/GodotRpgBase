extends Node2D

func _ready():
	randomize()  # only call this, when you want to change the random seed!

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit(0)
