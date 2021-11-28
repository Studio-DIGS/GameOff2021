extends Node2D

#Array which contains all the scenes to pick from
#NOTE: Every level should be 3072 units tall, with origin being at the bottom left of the parent node
onready var Scenes = [
	preload("res://Scenes/Levels/Level2.tscn"),
	preload("res://Scenes/Levels/Level3.tscn")
]

#Wait time before spawning next scene in milliseconds
export var spawn_wait_time_ms = 12800

#Variables to be used in _process
var previous_spawn_time = 0
var rotator = 0
var changing_position = Vector2(-3072, 0)

#Rotating instance variables
var instanceOne
var instanceTwo
var instanceThree

#Randomizes seed and initializes 3 different instances
func _ready():
	randomize()
	instanceOne = random_choice(Scenes).instance()
	instanceTwo = random_choice(Scenes).instance()
	instanceThree = random_choice(Scenes).instance()

#Every spawn_wait_time_ms milliseconds, adds an instanceNumber scene to the world and deletes the instanceNumber scene 2 levels below it (i.e adding instanceThree also deletes instanceOne)
func _process(_delta):
	var time_diff = OS.get_system_time_msecs() - previous_spawn_time
	if time_diff > spawn_wait_time_ms:
		print("Static Memory Usage: ", OS.get_static_memory_usage())
		print("Dynamic Memory Usage: ", OS.get_dynamic_memory_usage())
		randomize()
		if rotator == 0:
			instanceOne = random_choice(Scenes).instance()
			call_deferred("add_child", instanceOne)
			instanceOne.position = changing_position
			changing_position += Vector2(0, -3072)
			instanceTwo.free()
			previous_spawn_time = OS.get_system_time_msecs()
			rotator += 1
		elif rotator == 1:
			instanceTwo = random_choice(Scenes).instance()
			call_deferred("add_child", instanceTwo)
			instanceTwo.position = changing_position
			changing_position += Vector2(0, -3072)
			instanceThree.free()
			previous_spawn_time = OS.get_system_time_msecs()
			rotator += 1
		else:
			instanceThree = random_choice(Scenes).instance()
			call_deferred("add_child", instanceThree)
			instanceThree.position = changing_position
			changing_position += Vector2(0, -3072)
			instanceOne.free()
			previous_spawn_time = OS.get_system_time_msecs()
			rotator = 0
	

#Given an array, returns a value at a random valid index
func random_choice(list: Array):
	if list.empty():
		push_error("Size of array is zero.")
		return
	return list[randi() % list.size()]
