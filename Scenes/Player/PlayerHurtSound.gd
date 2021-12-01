extends AudioStreamPlayer2D




func _on_PlayerHurtSound_finished():
	queue_free()
