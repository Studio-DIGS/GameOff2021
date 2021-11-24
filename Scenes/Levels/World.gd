extends Node2D

onready var Scenes = [
	preload("res://Scenes/Levels/Level2.tscn"),
	preload("res://Scenes/Levels/Level3.tscn")
]

onready var triggerZone = $TriggerZone

var has_entered_zone = false;

func _ready():
	randomize()

#Instances a random scene from Scenes as a child of World
func _on_TriggerZone_area_entered(area):
	if !has_entered_zone:
		var scene = random_choice(Scenes)
		var instance = scene.instance()
		call_deferred("add_child", instance)
		instance.global_position = triggerZone.global_position + Vector2(0, -512)
		has_entered_zone = true;

func random_choice(list: Array):
	if list.empty():
		push_error("Size of array is zero.")
		return
	return list[randi() % list.size()]
