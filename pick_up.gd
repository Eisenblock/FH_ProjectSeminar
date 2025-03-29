extends Node2D


@export var fireball_boolPIckUP : bool = false
@export var circleball_boolPickUp : bool = false

func _ready() -> void:
	pass


func GetPLayer():
	var nodes_in_group = get_tree().get_nodes_in_group("player")




func _on_pick_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if fireball_boolPIckUP :
			body.circleBall = true
		if circleball_boolPickUp:
			print("PIckUp")
			body.fireBall = true
		queue_free()
