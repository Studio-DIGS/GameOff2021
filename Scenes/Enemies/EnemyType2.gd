extends StaticBody2D

onready var find_player = $PlayerDetection
var bullet = load("res://Scenes/Effects/Bullet.tscn")
var bullet_Speed = 100
var playerLocation = null

func _physics_process(delta):
	if find_player.can_see_player():
		playerLocation = find_player.player.global_position
		attack(playerLocation - global_position)
		print("true")
		
	if find_player.can_see_player() == null:	
		print("false")

func attack(input):
	var bullet_instanced = bullet.instance()
	get_parent().add_child(bullet_instanced) # learn this Anthony
	bullet_instanced.position = global_position
	bullet_instanced.apply_impulse(Vector2.ZERO, input.normalized() * bullet_Speed)
