extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_Area2D_area_entered(area):
	player = area


func _on_Area2D_area_exited(area):
	player = null
