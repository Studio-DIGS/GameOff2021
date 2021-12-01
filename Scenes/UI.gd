extends Control

var hearts = 6 setget set_hearts
var max_hearts = 6 setget set_max_hearts

onready var heartUIFull = $HeartFull
onready var heartUIHalf = $HeartHalf
onready var heartUIEmpty = $HeartEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 56


func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 56

func _ready():
	self.max_hearts = Stats.max_health
	self.hearts = Stats.health
	Stats.connect("health_changed", self, "set_hearts")
	
