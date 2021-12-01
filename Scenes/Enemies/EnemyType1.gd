extends KinematicBody2D

onready var playerDetectionZone = $PlayerDetection
onready var sprite = $AnimatedSprite
var state = IDLE
var SPEED = 600
var velocity = Vector2.ZERO
var FRICTION = 600
var ACCELERATION = 400
var BOUNCE = -50


enum{
	IDLE,
	CHASE,
}

#onready var stats = $Stats
	
func _physics_process(delta):
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
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
