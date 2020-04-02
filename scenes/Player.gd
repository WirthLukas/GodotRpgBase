extends KinematicBody2D

enum State {
	MOVE, ROLL, ATTACK
}

const ACCELERATION = 400
const MAX_SPEED = 80
const FRICTION = 500

var state = State.MOVE
var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true


func _physics_process(delta):
	match state:
		State.MOVE:
			move_state(delta)
		State.ROLL:
			pass
		State.ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)   # adding input vector to attack animation
		animation_state.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)  # not + delta, because it handles this for us (see it in the docs)
	
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK


func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	return input_vector


func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func attack_animation_finished():
	state = State.MOVE
