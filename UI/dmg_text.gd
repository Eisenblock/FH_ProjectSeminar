extends Label

@export var dmg_value = 0

var timerDeath = 0

func _ready() -> void:
	self.text = str(dmg_value)

func _process(delta: float) -> void:
	self.text = str(dmg_value)
	timerDeath += delta
	if timerDeath >= 0.15 :
		self.queue_free()
