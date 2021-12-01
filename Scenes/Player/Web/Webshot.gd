extends RigidBody2D


var hit = false
var target = Vector2.ZERO

# webshot hits wall
func _on_Webshot_body_entered(body):
	queue_free()

# webshot goes out of range
func _on_Hitbox_area_exited(area):
	queue_free()

# webshot successfully hits target
func _on_Hitbox_body_entered(body): 
	hit = true
	target = body
