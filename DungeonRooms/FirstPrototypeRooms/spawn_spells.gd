extends Node2D
@onready var node_2d: Node2D = $"../Node2D"
@export var fireball_PickUP : PackedScene 
@export var darkball_PickUP :  PackedScene  
@export var circleball_PickUP : PackedScene  
@export var bumerang_PickUP : PackedScene  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnPickUP()
	"""if randNum == 3:
		instance = bumerang_PickUP.instantiate()
		instance.position = Vector2(31.265,-119)
		add_child(instance)"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SpawnPickUP() :
	var randNum
	randNum = randi_range(0,2) 
	var instance
	if randNum == 0:
		if not Global.learned_abilities.has("fireball") :
			instance = fireball_PickUP.instantiate()
			instance.position = Vector2(31.265,-119)
			add_child(instance)
			print("fireball")
		else :
			SpawnPickUP()
	
	if randNum == 1:
		if not Global.learned_abilities.has("darkball") :
			instance = darkball_PickUP.instantiate()
			instance.position = Vector2(31.265,-119)
			add_child(instance)
			print("darkball")
		else :
			SpawnPickUP()
	
	if randNum == 2:
		if not Global.learned_abilities.has("circleball") :
			instance = circleball_PickUP.instantiate()
			instance.position = Vector2(31.265,-119)
			add_child(instance)
			print("circleball")
		else :
			SpawnPickUP()
