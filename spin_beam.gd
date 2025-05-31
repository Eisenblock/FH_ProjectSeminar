extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var animated_sprite_2d_3: AnimatedSprite2D = $AnimatedSprite2D3
@onready var animated_sprite_2d_4: AnimatedSprite2D = $AnimatedSprite2D4
@onready var animated_sprite_2d_5: AnimatedSprite2D = $AnimatedSprite2D5
@onready var animated_sprite_2d_6: AnimatedSprite2D = $AnimatedSprite2D6
@onready var animated_sprite_2d_7: AnimatedSprite2D = $AnimatedSprite2D7
@onready var animated_sprite_2d_8: AnimatedSprite2D = $AnimatedSprite2D8

var dmg = 2
var rotation_speed := 1
 # Radians pro Sekunde (~57°/s)

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
	animated_sprite_2d_3.play("default")
	animated_sprite_2d_4.play("default")
	animated_sprite_2d_5.play("default")
	animated_sprite_2d_6.play("default")
	animated_sprite_2d_7.play("default")
	animated_sprite_2d_8.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(dmg)
