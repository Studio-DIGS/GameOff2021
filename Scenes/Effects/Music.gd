extends AudioStreamPlayer


func _ready():
	Stats.connect("no_health", self, "stop")
