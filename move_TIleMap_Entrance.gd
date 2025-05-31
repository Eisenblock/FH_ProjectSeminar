extends TileMap

var move_up := false
var move_duration := 2.0
var move_timer := 0.0
var move_speed := 20.0  # Pixel pro Sekunde
@export var direction = Vector2.ZERO 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if move_up:
		position += move_speed * delta * direction
		move_timer += delta
		if move_timer >= move_duration:
			move_up = false  # Bewegung stoppen

func StartMovement():
	move_up = true

func ResetMovement():
	move_up = true
	move_timer = 0
	direction *= -1
