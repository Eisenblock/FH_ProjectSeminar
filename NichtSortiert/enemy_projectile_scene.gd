extends Node2D
var direction 
var player 
@export var lifetime = 4
@export var dmg = 2
@export var speed = 50
@onready var animated_sprite_2d: AnimatedSprite2D = $Area2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	direction = (player.position - position).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		speed = 0
		animated_sprite_2d.play("destroy")
		await get_tree().create_timer(1).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	if animated_sprite_2d and lifetime >= 0 :
		animated_sprite_2d.play("fly")
	if direction != Vector2.ZERO :
		position += direction * speed * delta

func SetDir(dirRef:Vector2):
	direction = dirRef

func SetDmg(dmgRef :float):
	dmg = dmgRef

func Destroy():
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()
		player.take_damage(dmg)
		lifetime = 0
