extends KinematicBody2D

var SPEED = 500
var velocity = Vector2.ZERO
var FRICTION = 20
var ACCELERATION = 250
var BOUNCE = -20

enum{
	IDLE,
	CHASE,
}

#onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetection
var state = IDLE

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION *delta)
			prevent_collision(delta)
			seek_player()
		CHASE:
			prevent_collision(delta)
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
				
				velocity = move_and_slide(velocity)
			seek_player()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	else:
		state = IDLE

#checking for walls
func prevent_collision(delta):
	var collision_close = null
	$rays.rotation += delta* 11 * PI
	for ray in $rays.get_children():
		if ray.is_colliding():
			var collision_point = ray.get_collision_point() - global_position
			velocity += collision_point.normalized() * BOUNCE
