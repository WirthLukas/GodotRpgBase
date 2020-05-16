extends Node

export(int) var max_health = 1

# its like, if you would initialize, this variable in the _ready() func
# you need so, othervise it would assign the default value of max_health
onready var health = max_health setget set_health 

signal no_health

func set_health(value):
	health = value
	
	if health <= 0:
		emit_signal("no_health")


# func _ready():
#	health = max_health


# not a good way!
#func _process(delta):
#	if health <= 0:
#		emit_signal("no_health")
