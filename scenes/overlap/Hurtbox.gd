extends Area2D

const HitEffect = preload("res://scenes/effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	# you must use self.XXX in order to call the setter
	self.invincible = true
	timer.start(duration)


func create_hit_effect():
	var effect = HitEffect.instance()
	# you can not use the parent here, cause you would freeze it
	var world = get_tree().current_scene
	world.add_child(effect)
	# with little offset
	# you could also set the offset in the HitEffect Sprite
	effect.global_position = global_position - Vector2(0, 8)


func _on_Timer_timeout():
	# you must use self.XXX in order to call the setter
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	# when setting it to true, the cosisponding signals gets 
	# recalled => solution for bat attack at a corner doesn't work
	set_deferred("monitorable", false)
	#set deffered, cause this gets called during physics process
	# so we have to call this method, so that the value gets changed after the game Loop


func _on_Hurtbox_invincibility_ended():
	monitorable = true
