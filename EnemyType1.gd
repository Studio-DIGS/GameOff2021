extends KinematicBody2D

var SPEED = 50
var velocity = Vector2.ZERO
var FRICTION = 10
var ACCELERATION = 30

enum{
	IDLE,
	WANDER,
	CHASE,
}

#onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetection
var state = CHASE

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION *delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
				
				velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	else:
		state = WANDER
	
