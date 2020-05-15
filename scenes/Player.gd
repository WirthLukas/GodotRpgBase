extends KinematicBody2D

enum State {
	MOVE, ROLL, ATTACK
}

const ACCELERATION = 400
const MAX_SPEED = 80
const ROLL_SPEED = 120 # roll should be a little faster than normal speed
const FRICTION = 500

var state = State.MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animation_tree.active = true
	swordHitbox.knockback_vector = roll_vector

# the function move_and_slide should be called in _physics_process
func _physics_process(delta):
	match state:
		State.MOVE:
			move_state(delta)
		State.ROLL:
			roll_state()
		State.ATTACK:
			attack_state()


func move_state(delta):
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)   # adding input vector to attack animation
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = State.ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK


func get_input_vector():
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	return input_vector


func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move()


func attack_state():
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func move():
	velocity = move_and_slide(velocity)  # not + delta, because it handles this for us (see it in the docs)


func roll_animation_finished():
	velocity = velocity * .8   # to reduce sliding at the end of the animation
	state = State.MOVE


func attack_animation_finished():
	state = State.MOVE
