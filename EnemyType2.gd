extends StaticBody2D

onready var find_player = $PlayerDetection
var bullet = load("res://Bullet.tscn")
var bullet_Speed = 100


func _physics_process(delta):
	if find_player.can_see_player() == true:
		print("true")
		attack()
	if find_player.can_see_player() == false:	
		print("false")

func attack(x):
	var bullet_instanced = bullet.instance()
	get_parent().add_child(bullet_instanced) # learn this Anthony
	bullet_instanced.position = global_position
	bullet_instanced.apply_impulse(Vector2.ZERO, x.normalized * bullet_Speed)
