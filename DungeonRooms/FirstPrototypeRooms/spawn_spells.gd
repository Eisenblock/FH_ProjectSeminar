extends Node2D
@onready var node_2d: Node2D = $"../Node2D"
@export var fireball_PickUP : PackedScene 
@export var darkball_PickUP :  PackedScene  
@export var circleball_PickUP : PackedScene  
@export var bumerang_PickUP : PackedScene  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randNum
	randNum = randi_range(0,3) 
	var instance
	if randNum == 0:
		instance = fireball_PickUP.instantiate()
		instance.position = Vector2(31.265,-119)
		add_child(instance)
	if randNum == 1:
		instance = darkball_PickUP.instantiate()
		instance.position = Vector2(31.265,-119)
		add_child(instance)
	if randNum == 2:
		instance = circleball_PickUP.instantiate()
		instance.position = Vector2(31.265,-119)
		add_child(instance)
	if randNum == 3:
		instance = bumerang_PickUP.instantiate()
		instance.position = Vector2(31.265,-119)
		add_child(instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
