extends KinematicBody2D

export var SPEED = 600.0
export var ACCELERATION = 20.0
export var TERMINAL_VELOCITY = 1000.0
export var AIR_ACCELERATION = 5.0
export var JUMP_HEIGHT = 200.0
export var JUMP_PEAK = 0.5 # time to peak of jump
export var JUMP_DESCENT = 0.4 # time to descend
export var SHOOT_SPEED = 1000.0

onready var jump_velocity = ((2.0 * JUMP_HEIGHT) / JUMP_PEAK) * -1.0
onready var jump_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_PEAK * JUMP_PEAK)) * -1.0
onready var fall_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_DESCENT * JUMP_DESCENT)) * -1.0

onready var ray_right = $Raycasts/right
onready var ray_left = $Raycasts/left
onready var web = $Cursor/Area2D
onready var cursor = $Cursor


enum {
	MOVE,
	GRAPPLE,
	DASH
}

var state = MOVE
var velocity = Vector2.ZERO

var target = self
var shoot_vector = Vector2.ZERO

func _physics_process(delta):
	#web.set_cast_to(get_local_mouse_position())
	cursor.global_position = get_global_mouse_position()
	
	match state:
		MOVE:
			move(delta)
		GRAPPLE:
			grapple()
		DASH:
			pass
	
	velocity = move_and_slide(velocity, Vector2.UP)

# MOVE STATE
func move(delta):
	var grounded = is_on_floor()
	var walled = get_wall()
	var input = get_input()
	
	velocity.y += clamp(get_gravity() * delta, 0, TERMINAL_VELOCITY)
	
	if grounded == true:
		velocity.x = lerp(velocity.x, input * SPEED, ACCELERATION * delta)
		if Input.is_action_just_pressed("jump"):
			jump()
	
	else: # less control in the air
		velocity.x = lerp(velocity.x, input * SPEED, AIR_ACCELERATION * delta)
	
	if walled != 0:
		velocity.y *= 0.8
		if Input.is_action_just_pressed("jump"):
			velocity.x = walled * SPEED * -1
			jump()
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, ACCELERATION * delta)
	
	if Input.is_action_just_pressed("shoot_web"):
		if web.get_overlapping_areas() != []:
			target = web.get_overlapping_areas()[0]
			#print(str(target))
			shoot_vector = (target.global_position - global_position)
			state = GRAPPLE
	

func get_input():
	var horizontal = 0
	if Input.is_action_pressed("right"):
		horizontal += 1
	if Input.is_action_pressed("left"):
		horizontal -= 1
	return horizontal

func jump():
	velocity.y = jump_velocity

func grapple():
	velocity = SHOOT_SPEED * shoot_vector.normalized()
	var distance = target.global_position - global_position
	if distance.length() < 60:
		state = MOVE  
	if Input.is_action_just_pressed("jump"):
		state = MOVE
		

func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_wall():
	var wall_state = 0
	if ray_right.is_colliding() && ray_left.is_colliding():
		wall_state = get_input()
	elif ray_right.is_colliding():
		wall_state = 1
	elif ray_left.is_colliding():
		wall_state = -1
	
	return wall_state
