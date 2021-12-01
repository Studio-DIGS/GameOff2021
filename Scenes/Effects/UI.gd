extends Control

var health = 0
var hearts = 12 setget set_hearts
var max_hearts = 12 setget set_max_hearts
var half_hearts = 12 setget set_hearts

onready var heartUIFull = $HeartFull
onready var heartUIHalf = $HeartHalf
onready var heartUIEmpty = $HeartEmpty

func set_hearts(value):
	print(str(value))
	health = value
	hearts = health / 2
	half_hearts = (health + 1) / 2
	
	hearts = clamp(hearts, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 56

	half_hearts = clamp(half_hearts, 0, max_hearts)
	if heartUIHalf != null:
		heartUIHalf.rect_size.x = half_hearts * 56

	


func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts / 2 * 56

func _ready():
	self.max_hearts = Stats.max_health
	self.health = Stats.health
	Stats.connect("health_changed", self, "set_hearts")
	Stats.connect("max_health_changed", self, "set_max_hearts")
	
