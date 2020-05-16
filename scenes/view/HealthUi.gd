extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var label = $Label

func set_hearts(value):
	# hearts should between 0 and max_hearts
	hearts = clamp(value, 0, max_hearts)
	if label != null:
		label.text = "HP = " + str(hearts)


func set_max_hearts(value):
	# max_hearts sould not be less than one
	max_hearts = max(value, 1)


func _ready():
	# we are using self, so that the set methog gets called
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
