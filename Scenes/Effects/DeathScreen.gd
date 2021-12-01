extends Camera2D

var restart = false

func _ready():
	Stats.connect("no_health", self, "game_over")

func _on_TriggerZone_area_entered(area):
	Stats.health = 0


func game_over():
	make_current()
	$scream.play()
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("shoot_web"):
		if restart:
			Stats.health = Stats.max_health
			get_tree().paused = false
			get_tree().reload_current_scene()


func _on_scream_finished():
	restart = true
