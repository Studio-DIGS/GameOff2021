extends Camera2D

var restart = false

func _ready():
	Stats.connect("no_health", self, "game_over")

func _on_TriggerZone_area_entered(area):
	game_over()


func _input(event):
	if event.is_action_pressed("shoot_web"):
		if restart:
			get_tree().reload_current_scene()


func game_over():
	restart = true
	make_current()
	$AudioStreamPlayer2D.play()
	Stats.health = Stats.max_health
