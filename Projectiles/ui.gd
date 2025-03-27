extends Node2D

@export var buttonMapChange : Array[PackedScene]

func _ready() -> void:
	choseMap()


func choseMap():
	var randnum = randi() % buttonMapChange.size() - 1
	if buttonMapChange.size() > 0 :
		var instance = buttonMapChange[randnum].instantiate()
		instance.position = Vector2(400,200)
		add_child(instance)
