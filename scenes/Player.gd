extends KinematicBody2D

const ACCELERATION = 400
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# returns an optimized velocity vector (for examples in edges)
	velocity = move_and_slide(velocity)  # not + delta, because it handles this for us (see it in the docs)

func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	return input_vector
