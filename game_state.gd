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
var lastRandValue = -1
var lastTag = ""

func _ready():
	if Global.global_maxRooms == 0 :
		Global.global_maxRooms = max_rooms 
	else :
		max_rooms = Global.global_maxRooms
	Global.enemyList = []
	SpawnStartArea()
	
	for i in range(max_rooms):
		# Raum instanziieren
		var randNum = randi() % 2
		if previous_exit != null :
			if previous_exit.is_in_group("Right"):
				var randNumi = randi() % room_scene_ERight.size() 
				if lastTag == "Right":
					if room_scene_ERight.size() > 1 :
						while true:
							randNumi = randi() % room_scene_ERight.size()
							if randNumi != lastRandValue:
								break
					else:
						randNumi = randi() % room_scene_ERight.size()  
				lastRandValue = randNumi
				lastTag = "Right"
				room = room_scene_ERight[randNumi].instantiate()
				var spawner = room.get_node("Area2D")
				add_child(room)
			if previous_exit.is_in_group("Down"):
				var randNumi = randi() % room_scene_EDown.size() 
				if lastTag == "Down":
					if room_scene_EDown.size() > 1 :
						while true:
							randNumi = randi() % room_scene_EDown.size()
							if randNumi != lastRandValue:
								break
					else:
						randNumi = randi() % room_scene_EDown.size()  
				lastRandValue = randNumi
				lastTag = "Down"
				room = room_scene_EDown[randNumi].instantiate()
				var spawner = room.get_node("Area2D")
				add_child(room)
		else : 
				room = room_scene_ERight[0].instantiate()
				var spawner = room.get_node("Area2D")
				add_child(room)
			# Position des Raums setzen
		if previous_exit and room != null:
			var room_start = room.get_node("StartPoint")
			room.position = previous_exit.global_position - room_start.position
		room_exit = room.get_node("EndPoint")
	
		if room_exit.is_in_group("Right"):
			var randNumi = randi() % corridor_scene_ERight.size() - 1
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
	
	room = room_scene.instantiate()
	add_child(room)
	var roomStart =  room.get_node("StartPoint")
	var roomPortal = room.get_node("Portal")
	roomPortal.portalActive = true
	lastRoom = true
	
	if previous_exit and room != null:
		var room_start = room.get_node("StartPoint")
		room.position = previous_exit.global_position - room_start.position
	
	#WeakEnemy
	Global.enemyCount_small_min += 2
	Global.enemyCount_small_max += 2
	#MediumENemy
	if Global.count_stage >= 3 :
		Global.enemyCount_medium_min += 1
		Global.enemyCount_medium_max += 1
	#Highenemy
	if Global.count_stage >=  5:
		Global.enemyCount_High_min += 1
		Global.enemyCount_High_max += 1
	#More Rooms
	max_rooms += 1
	Global.global_maxRooms += 1
	Global.count_stage += 1
	#update_all_navigation_regions()

func update_all_navigation_regions():
	for region in get_tree().get_nodes_in_group("NavigationRegion2D"):
		if region is NavigationRegion2D:
			var nav_map = region.get_navigation_map()
			if nav_map:
				# Alle Navigationsdaten aktualisieren
				NavigationServer2D.map_force_update(nav_map)
			else:
				print("Keine Navigation-Map gefunden in Region: ", region.name)

func _process(delta: float) -> void:
	#print("EnemyLIst",Global.enemyList.size())
	"""if Global.enemyList.size() <= 0 and !lastRoom :
		room = room_scene.instantiate()
		add_child(room)
		var roomStart =  room.get_node("StartPoint")
		var roomPortal = room.get_node("Portal")
		roomPortal.portalActive = true
		lastRoom = true
		
		if previous_exit and room != null:
			var room_start = room.get_node("StartPoint")
			room.position = previous_exit.global_position - room_start.position"""

func SpawnStartArea():
	room = room_scene_Start[0].instantiate()
	room_exit = room.get_node("EndPoint")
	add_child(room)
	if room_exit.is_in_group("Right"):
		var randNumi = randi() % 2
		corridor = corridor_scene_ERight[0].instantiate()
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
	
	var corridor_start = corridor.get_node("StartPoint")
	corridor.position = room_exit.global_position - corridor_start.position
	previous_exit = corridor.get_node("EndPoint")

func add_new_tilemap(tilemap: TileMap):
	var nav_map = $TileMap.get_navigation_map()
	if nav_map:
		NavigationServer2D.map_force_update(nav_map)
