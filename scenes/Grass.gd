extends Node2D


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()


func create_grass_effect():
	# for optimization you could add the grass effect sprite to this scene,
	# instead of making a seperate scene
	# you have to worry about, disabled the hurtbox, when playing the effect animation
	var GrassEffect = load("res://scenes/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance() # creates a node of the scene
	
	get_tree().current_scene.add_child(grassEffect) # thats the shorter form, if you dont need the world
	
	grassEffect.global_position = global_position # sets the position of the effect to this position
