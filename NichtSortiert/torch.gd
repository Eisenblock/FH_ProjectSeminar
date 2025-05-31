extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var torch : bool = false
@export var waterSplash : bool = false
var stopSPlash : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if torch :
		animated_sprite_2d.play("default")
	if waterSplash and !stopSPlash:
		animated_sprite_2d.play("default")
		await  get_tree().create_timer(1).timeout
		stopSPlash = true
	if stopSPlash :
		animated_sprite_2d.stop()
		await  get_tree().create_timer(4).timeout
		stopSPlash = false
