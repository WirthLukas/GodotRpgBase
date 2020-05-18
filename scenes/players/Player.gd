extends KinematicBody2D

enum State {
	MOVE, ROLL, ATTACK
}

export var ACCELERATION = 400
export var MAX_SPEED = 80
export var ROLL_SPEED = 120 # roll should be a little faster than normal speed
export var FRICTION = 500

const PlayerHurtSound = preload("res://scenes/players/PlayerHurtSound.tscn")

var state = State.MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats	# global auto load singleton

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blink_animation_player = $BlinkAnimationPlayer

func _ready():
	stats.connect("no_health", self, "queue_free")
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
		# PlayerStats.max_health -= 1
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


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var player_hurt_sound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(player_hurt_sound)


func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
