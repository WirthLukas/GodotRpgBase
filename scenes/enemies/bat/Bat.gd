extends KinematicBody2D

enum State {
	IDLE,
	WANDER,
	CHASE
}

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

const EnemyDeathEffect = preload("res://scenes/effects/EnemyDeathEffect.tscn")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = State.CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision


func _physics_process(delta):
	# applying Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		State.WANDER:
			pass
		
		State.CHASE:
			if playerDetectionZone.can_see_player():
				var player = playerDetectionZone.player
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				# when the player got out of the Detection Range 
				state = State.IDLE
			
			sprite.flip_h = velocity.x < 0
	
	# the bats should not overlap each other
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = State.CHASE


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
