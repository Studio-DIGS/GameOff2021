extends StaticBody2D

onready var find_player = $PlayerDetection
onready var timer = $PTimer
var bullet = load("res://Scenes/Effects/Bullet.tscn")
var bullet_Speed = 1500
var playerLocation = null
var can_shoot = true

func _physics_process(delta):
	if find_player.can_see_player():
		playerLocation = find_player.player.global_position
		if can_shoot:
			attack(playerLocation - global_position)
			print("true")
		
	if find_player.can_see_player() == null:	
		print("false")

func attack(input):
	var bullet_instanced = bullet.instance()
	get_parent().add_child(bullet_instanced) # learn this Anthony
	bullet_instanced.look_at(input)
	bullet_instanced.position = global_position
	bullet_instanced.apply_impulse(Vector2.ZERO, input.normalized() * bullet_Speed)
	timer.start(1)
	can_shoot = false

func _on_Timer_timeout():
	can_shoot = true # Replace with function body.
