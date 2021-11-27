extends KinematicBody2D

# player movement constants
export var SPEED = 600.0
export var ACCELERATION = 20.0
export var TERMINAL_VELOCITY = 1000.0
export var AIR_ACCELERATION = 1.75
# jump constants
export var JUMP_HEIGHT = 250.0
export var JUMP_PEAK = 0.5 # time to peak of jump
export var JUMP_DESCENT = 0.4 # time to descend
# grapple mechanic constants
export var GRAPPLE_SPEED = 1500.0 #speed player moves toward grapple point
export var WEBSHOT_SPEED = 1800.0 #speed webshot shoots toward grapple points

# jump calculations
onready var jump_velocity = ((2.0 * JUMP_HEIGHT) / JUMP_PEAK) * -1.0
onready var jump_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_PEAK * JUMP_PEAK)) * -1.0
onready var fall_gravity = ((-2.0 * JUMP_HEIGHT) / (JUMP_DESCENT * JUMP_DESCENT)) * -1.0

# import nodes
onready var ray_right = $Raycasts/right
onready var ray_left = $Raycasts/left
onready var cursor = $Cursor
onready var cursor_area = $Cursor/CursorArea
onready var web = $WebAnimation

var webshot = preload("res://Scenes/Player/Webshot.tscn")
signal shoot_web()


enum {
	MOVE,
	GRAPPLE
}

var state = MOVE
var velocity = Vector2.ZERO

# webshooting variables
var lockon = null
var prev_lockon = null
var target = Vector2.ZERO
var aim = Vector2.ZERO
var webshot_instance = null
var active_shot = false



func _physics_process(delta):
	cursor.position = get_local_mouse_position()
	
	if active_shot:
		if is_instance_valid(webshot_instance):
			web.look_at(webshot_instance.position)
			var distance = (webshot_instance.global_position - global_position).length()
			web.tip = Vector2(distance, 0)
			if webshot_instance.hit:
				target = webshot_instance.target
				state = GRAPPLE
				webshot_instance.queue_free()
		else:
			active_shot = false
			web.tip = Vector2.ZERO
	
	match state:
		MOVE:
			move(delta)
		GRAPPLE:
			grapple()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	update()

# MOVE STATE
func move(delta):
	target = Vector2.ZERO
	
	if lockon:
		aim = lockon.global_position - global_position
	else:
		aim = cursor.position
	
	var grounded = is_on_floor()
	var walled = get_wall()
	var input = get_input()
	
	velocity.y += clamp(get_gravity() * delta, 0, TERMINAL_VELOCITY)
	
	if grounded == true:
		velocity.x = lerp(velocity.x, input * SPEED, ACCELERATION * delta)
		if Input.is_action_just_pressed("jump"):
			jump()
			
	elif walled != 0:
		velocity.y *= 0.8
		if Input.is_action_just_pressed("jump"):
			velocity.x = walled * SPEED * -1.5
			jump()
	
	else: # less control in the air
		velocity.x = lerp(velocity.x, input * SPEED, AIR_ACCELERATION * delta)
	

	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0, ACCELERATION * delta)
	
	if Input.is_action_just_pressed("shoot_web") and active_shot == false:
		shoot()
	

func get_input():
	var horizontal = 0
	if Input.is_action_pressed("right"):
		horizontal += 1
	if Input.is_action_pressed("left"):
		horizontal -= 1
	return horizontal

func jump():
	velocity.y = jump_velocity

func shoot():
	emit_signal("shoot_web")
	
	web.freq = 0.2
	active_shot = true
	webshot_instance = webshot.instance()
	webshot_instance.position = get_global_position()
	webshot_instance.apply_impulse(Vector2.ZERO, aim.normalized() * WEBSHOT_SPEED)
	get_parent().add_child(webshot_instance)
	
	
	
# GRAPPLE STATE
func grapple():
	var trajectory = target.global_position - global_position
	web.tip = Vector2(trajectory.length(), 0)
	velocity = GRAPPLE_SPEED * trajectory.normalized()
	if trajectory.length() < 40:
		velocity = SPEED * 2 * trajectory.normalized()
		web.tip = Vector2.ZERO
		state = MOVE
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("shoot_web"):
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


func _draw():
	#draw_line(Vector2(), aim, Color(0,1,0))
	pass




func _on_CursorArea_area_entered(area):
	prev_lockon = lockon
	lockon = area


func _on_CursorArea_area_exited(area):
	if area == lockon:
		lockon = prev_lockon
	prev_lockon = null


func _on_CancelGrapple_body_entered(body):
	if state == GRAPPLE:
		state = MOVE
