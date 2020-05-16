extends Node

export(int) var max_health = 1

# its like, if you would initialize, this variable in the _ready() func
# you need so, othervise it would assign the default value of max_health
onready var health = max_health setget set_health 

signal no_health
signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("no_health")

