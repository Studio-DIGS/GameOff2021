extends Camera2D

const HEIGHT_OF_MODULE = 3072

export var time_to_scroll_through_module_sec = 12.80
export var final_time_to_scroll_through_module_sec = 7.50

onready var timer = $Timer

var game_is_playing = false

#Camera speed variables
var camera_speed = HEIGHT_OF_MODULE/time_to_scroll_through_module_sec
var initial_cam_speed = camera_speed
var weight = 0.0

#Starts a timer for incrementing speed of camera
func _ready():
	timer.start(3072 / initial_cam_speed)

#Moves camera up camera_speed units every second
func _physics_process(delta):
	if game_is_playing:
		position.y -= camera_speed * delta

#Deletes the camera, triggerzone is also connected to DeathScreen camera2d, which makes it the current camera
func _on_TriggerZone_area_entered(area):
	queue_free()

#Function activates every time a new module is put into the world
#Increments weight slightly to increase camera speed by said weight% from initial camera speed
func _on_Timer_timeout():
	if weight < 1:
		weight += 0.1
	camera_speed = lerp(initial_cam_speed, HEIGHT_OF_MODULE/final_time_to_scroll_through_module_sec, weight)
	timer.start(HEIGHT_OF_MODULE / camera_speed)


func _on_StartGameZone_area_entered(area):
	make_current()
	timer.start(3072 / initial_cam_speed)
	game_is_playing = true
