extends KinematicBody2D

var speed = 20
var velocity = Vector2.ZERO

enum{
	IDLE,
	WANDER,
	CHASE,
}

#onready var stats = $Stats
var state = CHASE

func _physics_process(delta):
	match state:
		IDLE:
			pass
		WANDER:
			pass
		CHASE:
			pass

func chasePlayer(delta):
	velocity = 0
	
