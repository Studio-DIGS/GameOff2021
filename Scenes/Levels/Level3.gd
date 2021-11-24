extends Node2D

onready var Scenes = [
	load("res://Scenes/Levels/Level2.tscn")
]

onready var triggerZone = $TriggerZone

var has_entered_zone = false;
var scene
var instance

func _ready():
	randomize()

func _on_TriggerZone_area_entered(area):
	if !has_entered_zone:
		scene = random_choice(Scenes)
		instance = scene.instance()
		call_deferred("add_child", instance)
		instance.position += triggerZone.position + Vector2(0, -2048)
		has_entered_zone = true
		#TODO: queue free the instanced level below this scene / queue free the level that instanced this scene

func random_choice(list: Array):
	if list.empty():
		push_error("Size of array is zero.")
		return
	return list[randi() % list.size()]
	
