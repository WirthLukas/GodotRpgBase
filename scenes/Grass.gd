extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		# Scene instances are written Upercase
		# gets called a packed scene (its only a scene not a node in the game)
		var GrassEffect = load("res://scenes/GrassEffect.tscn")
		var grassEffect = GrassEffect.instance() # creates a node of the scene
		
		var world = get_tree().current_scene # gets the root node of the node tree, in our case World
		world.add_child(grassEffect)
		
#		get_tree().current_scene.add_child(grassEffect) # thats the shorter form, if you dont need the world
		
		grassEffect.global_position = global_position # sets the position of the effect to this position
		
		queue_free()		# waits until the end of the frame until the engine destroyes that node
