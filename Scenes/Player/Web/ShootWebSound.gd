extends AudioStreamPlayer2D



func _on_ShootWebSound_finished():
	queue_free()
