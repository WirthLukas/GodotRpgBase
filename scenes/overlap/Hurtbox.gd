extends Area2D

export(bool) var show_hit = true
const HitEffect = preload("res://scenes/effects/HitEffect.tscn")


func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = HitEffect.instance()
		# you can not use the parent here, cause you would freeze it
		var world = get_tree().current_scene
		world.add_child(effect)
		# with little offset
		# you could also set the offset in the HitEffect Sprite
		effect.global_position = global_position - Vector2(0, 8)
