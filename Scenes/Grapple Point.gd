extends Node2D

onready var lockon_visual = $able

var lockon = null
var prev_lockon = null

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
