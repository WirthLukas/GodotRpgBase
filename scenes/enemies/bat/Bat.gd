extends KinematicBody2D

enum State {
	IDLE,
	WANDER,
	CHASE
}

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

const EnemyDeathEffect = preload("res://scenes/effects/EnemyDeathEffect.tscn")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = State.CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController


func _ready():
	state = pick_random_state([State.IDLE, State.WANDER])


func _physics_process(delta):
	# applying Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
		
		State.WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wanderController.target_position, delta)
			
			# if the bat is close enough to the wanderController's position
			# it should randomly pick another state
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		
		State.CHASE:
			if playerDetectionZone.can_see_player():
				var player = playerDetectionZone.player
				accelerate_towards_point(player.global_position, delta)
			else:
				# when the player got out of the Detection Range 
				state = State.IDLE
	
	# the bats should not overlap each other
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)


func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0


func update_wander():
	state = pick_random_state([State.IDLE, State.WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))


func seek_player():
	if playerDetectionZone.can_see_player():
		state = State.CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	# parent should be the Y-Sort node
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = self.global_position
