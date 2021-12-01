extends Node2D

onready var line = $Line2D
onready var tip = $Line2D/StaticBody2D

onready var a = 1
onready var amp = 100
onready var freq = 0
onready var k = 0.01
onready var per = PI

var accel = 100
var pos = Vector2.ZERO
var pos2 = Vector2.ZERO
var p = 0




func _process(delta):
	tip.global_position = get_global_mouse_position()
	look_at(tip.global_position)
	freq = wrapf(freq + 0.1 * delta, -0.1, 0.1)
	if Input.is_action_pressed("shoot_web"):
		update()

#func spawn_web(delta):
#
#	line.clear_points()
#	#line.set_point_position(p, Vector2.ZERO)
#	line.rotation = 0
#	#line.add_point(Vector2(-100, 100))
#	var target = get_global_mouse_position()
#	var theta = Vector2.RIGHT.angle_to(target.normalized())
#	line.rotate(theta)
#
#	for i in range(500):
#		line.add_point(pos)
#		pos = Vector2(i, sine(i))
#		if pos.x > tip.position.x:
#			print(str(line.get_point_count()))
#			p = i
#			break
##

		

func _draw():
	for i in range(10000):
		pos = Vector2(i, sine(i))
		pos2 = Vector2(i+1, sine(i+1))
		draw_line(pos, pos2, ColorN("white"), 1)
		if pos.x > tip.position.x:
			break


func sine(t):
	var y = amp * exp(-k * t) * sin(freq * t)
	return y
