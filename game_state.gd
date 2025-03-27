extends Node2D

@export var room_scene: PackedScene
@export var corridor_scene: PackedScene
@export var max_rooms: int = 2  # Anzahl der Räume mit Korridoren

@export var room_scene_Start: Array[PackedScene]
@export var room_scene_ERight: Array[PackedScene]
@export var room_scene_EDown: Array[PackedScene]
@export var corridor_scene_ERight: Array[PackedScene]
@export var corridor_scene_EDown: Array[PackedScene]

var previous_exit = null
var room = null
var room_exit = null
var corridor = null
var lastRoom : bool = false

func _ready():
	Global.enemyList = []
	SpawnStartArea()
	
	for i in range(max_rooms):
		# Raum instanziieren
		var randNum = randi() % 2
		if previous_exit != null :
			if previous_exit.is_in_group("Right"):
				var randNumi = randi() % 2
				room = room_scene_ERight[0].instantiate()
				Global.enemySpawnCount += 1 + i 
				add_child(room)
			if previous_exit.is_in_group("Down"):
				var randNumi = randi() % 1
				room = room_scene_EDown[0].instantiate()
				Global.enemySpawnCount = 1 + i 
				add_child(room)
		else : 
			room = room_scene_ERight[0].instantiate()
			Global.enemySpawnCount = 1 + i 
			add_child(room)
	
		# Position des Raums setzen
		if previous_exit and room != null:
			var room_start = room.get_node("StartPoint")
			room.position = previous_exit.global_position - room_start.position
		room_exit = room.get_node("EndPoint")
	
		if room_exit.is_in_group("Right"):
			var randNumi = randi() % 2
			corridor = corridor_scene_ERight[randNumi].instantiate()
			add_child(corridor)
		if room_exit.is_in_group("Down"):
			var randNumi = randi() % 2
			corridor = corridor_scene_EDown[0].instantiate()
			add_child(corridor)
		if room_exit.is_in_group("Up"):
			corridor = corridor_scene.instantiate()
			add_child(corridor)
		if room_exit.is_in_group("Left"):
			corridor = corridor_scene.instantiate()
			add_child(corridor)



		# Position des Korridors setzen
		var corridor_start = corridor.get_node("StartPoint")
		corridor.position = room_exit.global_position - corridor_start.position

		# Den neuen Endpunkt für die nächste Iteration speichern
		previous_exit = corridor.get_node("EndPoint")

func _process(delta: float) -> void:
	#print("EnemyLIst",Global.enemyList.size())
	if Global.enemyList.size() <= 0 and !lastRoom :
		room = room_scene.instantiate()
		add_child(room)
		var roomStart =  room.get_node("StartPoint")
		var roomPortal = room.get_node("Portal")
		roomPortal.portalActive = true
		lastRoom = true
		
		if previous_exit and room != null:
			var room_start = room.get_node("StartPoint")
			room.position = previous_exit.global_position - room_start.position

func SpawnStartArea():
	room = room_scene_Start[0].instantiate()
	room_exit = room.get_node("EndPoint")
	add_child(room)
	if room_exit.is_in_group("Right"):
		var randNumi = randi() % 2
		corridor = corridor_scene_ERight[randNumi].instantiate()
		add_child(corridor)
	if room_exit.is_in_group("Down"):
		var randNumi = randi() % 2
		corridor = corridor_scene_EDown[randNumi].instantiate()
		add_child(corridor)
	if room_exit.is_in_group("Up"):
		corridor = corridor_scene.instantiate()
		add_child(corridor)
	if room_exit.is_in_group("Left"):
		corridor = corridor_scene.instantiate()
		add_child(corridor)
	
	var corridor_start = corridor.get_node("StartPoint")
	corridor.position = room_exit.global_position - corridor_start.position
	previous_exit = corridor.get_node("EndPoint")
