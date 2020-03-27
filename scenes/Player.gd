extends KinematicBody2D

const ACCELERATION = 400
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		# we defined a triangle, where each animation is set to a point
		# we can assign any vector to the blend postion (it determines, which animation gets played)
		# so we can also assign the input vector
		# --------------------
		# we defined Animation up and animation down to 1.1 so that animation left and right (are on 1)
		# are prioritized
		# --------------------
		# these "parameters/..." are the path to the properties you can see on the inspector on the right side
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")

		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# returns an optimized velocity vector (for examples in edges)
	velocity = move_and_slide(velocity)  # not + delta, because it handles this for us (see it in the docs)


func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	return input_vector
