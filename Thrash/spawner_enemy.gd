extends Node2D

@onready var area_trigger: Area2D = $AreaTrigger
@export var enemyWeak : PackedScene
@export var spawnRate : float = 3
var timerSpawnEnemy : Timer
var spawnStarted : bool = false

func _ready() -> void:
	StartSpawning()


func _process(delta: float) -> void:
	if spawnStarted == true :
		spawnStarted = false
		StartSpawning()
	

func StartSpawning():
	spawnRate -= 0.1
	timerSpawnEnemy = Timer.new()
	add_child(timerSpawnEnemy)
	timerSpawnEnemy.wait_time = spawnRate
	timerSpawnEnemy.one_shot = false
	timerSpawnEnemy.connect("timeout", self.SpawningEnemy)
	timerSpawnEnemy.start()


func SpawningEnemy():
	var instance = enemyWeak.instantiate()
	instance.position = global_position
	Global.enemyList.append(instance)
	Global.enemyList_lost.append(instance)
	get_tree().root.add_child(instance)


func _on_area_trigger_area_entered(area: Area2D) -> void:
	pass
