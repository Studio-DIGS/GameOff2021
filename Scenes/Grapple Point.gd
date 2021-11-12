extends Node2D

onready var able_visual = $able

func _on_Area2D_area_entered(area):
	print("yes")
	able_visual.visible = true


func _on_Area2D_area_exited(area):
	able_visual.visible = true


func _on_Area2D_body_entered(body):
	print("yes")
