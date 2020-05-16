extends Node

export(int) var max_health = 1 setget set_max_health

# its like, if you would initialize, this variable in the _ready() func
# you need so, othervise it would assign the default value of max_health
onready var health = max_health setget set_health 

signal no_health
signal health_changed(value)
signal max_health_changed(value)


func set_health(value):
	health = value
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("no_health")


func set_max_health(value):
	max_health = value
	
	# health should no be higher than max_health
	if health != null:
		self.health = min(health, max_health)
	
	emit_signal("max_health_changed", max_health)
