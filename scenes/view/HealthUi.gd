extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
var texture_width = 15

onready var heartUiFull = $HeartUiFull
onready var heartUiEmpty = $HeartUiEmpty

func set_hearts(value):
	# hearts should between 0 and max_hearts
	hearts = clamp(value, 0, max_hearts)
	
	if heartUiFull != null:
		heartUiFull.rect_size.x = hearts * texture_width


func set_max_hearts(value):
	# max_hearts sould not be less than one
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	
	if heartUiEmpty != null:
		heartUiEmpty.rect_size.x = max_hearts * texture_width


func _ready():
	# we are using self, so that the set methog gets called
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
