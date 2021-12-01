extends Node2D

onready var lockon_visual = $able

export var SPEED = 0.005
onready var x = lockon_visual.scale.x
onready var y = lockon_visual.scale.y
var max_scale = 0.06
var min_scale = 0.04

var lockon = null
var prev_lockon = null

func _physics_process(delta):
#	lockon_visual.scale.x = wrapf(lockon_visual.scale.x + SPEED * delta, 0.04, 0.06)
#	lockon_visual.scale.y = wrapf(lockon_visual.scale.y + SPEED * delta, 0.04, 0.06)
#
	x = clamp(x + SPEED * delta, min_scale, max_scale)
	y = clamp(y + SPEED * delta, min_scale, max_scale)
	if x == max_scale or x == min_scale:
		SPEED = -1 * SPEED
	
	lockon_visual.scale = Vector2(x,y)
	


func _on_Area2D_area_entered(area):
	prev_lockon = lockon
	lockon = area
	if lockon:
		lockon_visual.visible = true
	

func _on_Area2D_area_exited(area):
	if area == lockon:
		lockon = prev_lockon
	prev_lockon = null
	lockon_visual.visible = false
