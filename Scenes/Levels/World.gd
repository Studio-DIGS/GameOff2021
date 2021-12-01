extends Node2D

#NOTE: Every level should be 3072 units tall, with origin being at the bottom left of the parent node

#Arrays of each pool of levels, separated by difficulty
onready var EasyPool = [
	preload("res://Scenes/Levels/Easy/Easy1.tscn"),
	preload("res://Scenes/Levels/Easy/Easy2.tscn")
]
onready var MediumPool = [
	preload("res://Scenes/Levels/Medium/Medium1.tscn"),
	preload("res://Scenes/Levels/Medium/Medium2.tscn"),
	preload("res://Scenes/Levels/Medium/Medium3.tscn")
]
onready var HardPool = [
	preload("res://Scenes/Levels/Hard/Hard1.tscn"),
	preload("res://Scenes/Levels/Hard/Hard2.tscn")
]

#Constants
const HEIGHT_OF_MODULE = 3072

#Amount to change to next pool variables
export var amt_to_medium_pool = 5
export var amt_to_hard_pool = 5

#Camera Speed Variables
export var spawn_wait_time_sec = 12.800
export var final_spawn_wait_time_sec = 7.50
var final_spawn_wait_time_ms = final_spawn_wait_time_sec * 1000
var spawn_wait_time_ms = spawn_wait_time_sec * 1000
var initial_spawn_wait_time_ms = spawn_wait_time_ms
var weight = 0.0

#Variables to be used in _process
var rotator = 0
var changing_position = Vector2(2048, 0)
onready var cur_pool = EasyPool

#variables for level generation
var instanceOne
var instanceTwo
var instanceThree
var cur_module = 0

#Randomizes seed and initializes 3 different instances
func _ready():
	randomize()
	instanceOne = random_choice(EasyPool).instance()
	instanceTwo = random_choice(EasyPool).instance()
	instanceThree = random_choice(EasyPool).instance()

#Given an array, returns a value at a random valid index
func random_choice(list: Array):
	if list.empty():
		push_error("Size of array is zero.")
		return
	return list[randi() % list.size()]

#Generates a module from pool, assigns it to instance_to_add, and frees instance_to_remove from memory
func generate_and_free_module (instance_to_add, instance_to_remove, pool):
	instance_to_add = generate_module(instance_to_add, pool)
	instance_to_remove.queue_free()
	return instance_to_add

func generate_module(instance_to_add, pool):
	instance_to_add = random_choice(pool).instance()
	call_deferred("add_child", instance_to_add)
	instance_to_add.position = changing_position
	changing_position += Vector2(0, -HEIGHT_OF_MODULE)
	rotator += 1
	cur_module += 1
	return instance_to_add

#Function activates every time a new module is put into the world
#Increments weight slightly to increase spawn time of modules by said weight% from initial spawn time
func _on_Timer_timeout():
	if cur_module >= amt_to_medium_pool:
		cur_pool = MediumPool
	if cur_module >= (amt_to_medium_pool + amt_to_hard_pool):
		cur_pool = HardPool
	randomize()
	if rotator == 0:
		instanceOne = generate_and_free_module(instanceOne, instanceTwo, cur_pool)
	elif rotator == 1:
		instanceTwo = generate_and_free_module(instanceTwo, instanceThree, cur_pool)
	else:
		instanceThree = generate_and_free_module(instanceThree, instanceOne, cur_pool)
		rotator = 0
	if weight < 1:
		weight += 0.1
	spawn_wait_time_ms = lerp(initial_spawn_wait_time_ms, final_spawn_wait_time_ms, weight)

func _on_StartGameZone_area_entered(area):
	generate_module(instanceOne, EasyPool)
