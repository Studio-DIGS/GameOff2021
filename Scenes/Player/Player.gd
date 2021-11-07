extends KinematicBody2D

export var SPEED = 400.0
export var JUMP_HEIGHT = 200.0
export var JUMP_PEAK = 0.5 # time to peak of jump
export var JUMP_DESCENT = 0.4 # time to descend

onready var jump_velocity = ((2.0 * JUMP_HEIGHT) / JUMP_PEAK) * -1.0
onready var jump_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_PEAK * JUMP_PEAK)) * -1.0
onready var fall_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_DESCENT * JUMP_DESCENT)) * -1.0

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input() * SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)

func jump():
	velocity.y = jump_velocity

func get_input():
	var input = 0
	if Input.is_action_pressed("right"):
		input += 1
	if Input.is_action_pressed("left"):
		input -= 1
	
	return input

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
