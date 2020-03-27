extends KinematicBody2D

enum Direction { UP, DOWN, LEFT, RIGHT }

const ACCELERATION = 400
const MAX_SPEED = 80
const FRICTION = 500

var velocity = Vector2.ZERO
var direction = Direction.RIGHT

onready var animation_player = $AnimationPlayer

# you have to do this, when you dont use an onready variable
#func _ready():
#	animation_player = $AnimationPlayer

func _physics_process(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		set_direction(input_vector)
		play_animation(direction, true)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		play_animation(direction, false)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# returns an optimized velocity vector (for examples in edges)
	velocity = move_and_slide(velocity)  # not + delta, because it handles this for us (see it in the docs)


func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	return input_vector


func set_direction(input_vector):
	if input_vector.y > 0:
		direction = Direction.DOWN
	elif input_vector.y < 0:
		direction = Direction.UP
		
	if input_vector.x > 0:
		direction = Direction.RIGHT
	elif input_vector.x < 0 :
		direction = Direction.LEFT


func play_animation(dir, moving):
	var animation = ""
	
	match dir:
		Direction.LEFT:
			# Ternary operator; in other languages "condition ? x : y"
			animation = "Run_Left" if moving else "Idle_Left"
		Direction.RIGHT:
			animation = "Run_Right" if moving else "Idle_Right"
		Direction.UP:
			animation = "Run_Up" if moving else "Idle_Up"
		Direction.DOWN:
			animation = "Run_Down" if moving else "Idle_Down"
		_:
			print("you should never ever be here!")
	
	animation_player.play(animation)
