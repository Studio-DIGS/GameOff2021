extends Node2D

var tip = Vector2.ZERO


export var MAX_AMP = 100
export var MAX_FREQ = 0.3
export var k = 0.01
export var AMP_SPEED = 5
export var FREQ_SPEED = 7

var pos = Vector2.ZERO
var pos2 = Vector2.ZERO
var width = 3.5
var amp_t = 0
var amp = 0
var freq = 0


func _process(delta):
#	tip = get_global_mouse_position()
#	if Input.is_action_just_pressed("shoot_web"):
#		amp = MAX_AMP
#		freq = MAX_FREQ
	#oscillate(amp_t, -amp, amp, delta)
	amp_t = clamp(amp_t + AMP_SPEED * amp * delta, -amp, amp)
	if amp_t == amp or amp_t == -amp:
		AMP_SPEED = -1 * AMP_SPEED
	
	amp = lerp(amp, 5, delta)
	freq = lerp(freq, 0, FREQ_SPEED * delta)
	update()
	

func _draw():
	for i in range(10000):
		pos = Vector2(i, sine(i))
		pos2 = Vector2(i+1, sine(i+1))
		draw_line(pos, pos2, ColorN("white"), width)
		if pos2.x > tip.x:
			draw_circle(pos2, width, ColorN("white"))
			break
		


func sine(t):
	var y = amp_t * exp(-k * t) * sin(freq * t)
	return y


func _on_Player_shoot_web():
	amp = MAX_AMP
	freq = MAX_FREQ
