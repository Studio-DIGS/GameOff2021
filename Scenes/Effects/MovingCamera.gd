extends Camera2D

#NOTE: if camera_speed changes, spawn_wait_time_ms in World.gd must decrease, or else scenes may not load in time
export var camera_speed = 3072/12.80

#Moves camera up camera_speed units every second
func _process(delta):
	position.y -= camera_speed * delta

#Notifies in output that player has entered deathbox, and deletes the camera, setting screen to (0,0)
func _on_TriggerZone_area_entered(area):
	print("Player has died")
	queue_free()
