extends Line2D
#
#onready var a = 1
#onready var amp = 100
#onready var freq = 0.1
#onready var k = 0.01
#
#onready var accel = 10
#
#
#var pos = Vector2.ZERO
#
##func _ready():
##	var pos = Vector2(0, sine(0))
##	for i in 2000:
##		add_point(pos)
##		pos = Vector2(i+1, sine(i+1))
#
#func _process(delta):
#	if Input.is_action_pressed("shoot_web"):
#		spawn_web(delta)
#
#func spawn_web(delta):
#	clear_points()
#	var target = get_global_mouse_position()
#	var theta = Vector2.RIGHT.angle_to(target.normalized())
#	#rotate(theta)
#	for i in range(500):
#		add_point(pos)
#		pos = Vector2(i, sine(i))
#		# transformation
##		pos.x = pos.x * cos(theta) - pos.y * sin(theta)
##		pos.y = pos.x * sin(theta) + pos.y * cos(theta)
#
#
#func parabola(x):
#	var a = 0.002
#	var y = -a * x * x + 10
#	return y
#
#func sine(t):
#	var y = amp * exp(-k * t) * sin(freq * t)
#	return y
