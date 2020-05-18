extends AnimatedSprite


func _ready():
	# connect to a signal by code
# warning-ignore:return_value_discarded
	self.connect("animation_finished", self, "_on_animation_finished")
	play("Animate")


func _on_animation_finished():
	queue_free()
