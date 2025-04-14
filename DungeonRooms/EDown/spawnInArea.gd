extends Area2D

@export var enemy_scene: PackedScene 
@export var enemy_10hp: PackedScene 
@export var enemy_30hp: PackedScene 
@export var enemy_50hp: PackedScene 
@export var isInCorridor : bool = false

 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randNum_small = randi_range(Global.enemyCount_small_min,Global.enemyCount_small_max)
	print(randNum_small)
	var randNum_medium = randi_range(Global.enemyCount_medium_min,Global.enemyCount_medium_max)
	print(randNum_medium)
	var randNum_High = randi_range(Global.enemyCount_High_min,Global.enemyCount_High_max)
	print(randNum_High)
	if isInCorridor :
		randNum_small = randNum_small / 2
		if randNum_small < 1  :
			randNum_small = 0
		randNum_medium = randNum_medium / 2
		if randNum_medium < 1  :
			randNum_medium = 0
		randNum_High = randNum_High / 2
		if randNum_High < 1  :
			randNum_High = 0
	for i in range(randNum_small):
		#print("SPawnt")
		var currentPos = get_random_position()
		spawn_enemy(currentPos,enemy_10hp)
	for q in range(randNum_medium):
		#print("SPawnt1")
		var currentPos = get_random_position()
		spawn_enemy(currentPos,enemy_30hp)
	for e in range(randNum_High):
		#print("SPawnt2")
		var currentPos = get_random_position()
		spawn_enemy(currentPos,enemy_50hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(pos : Vector2 , current_Scene : PackedScene):
	if enemy_scene:
		var enemy = current_Scene.instantiate()
		enemy.position = pos  # Spawnt am Ort von Area2D
		add_child(enemy)  # Fügt den Gegner zur Szene hinzu
		Global.enemyList.append(enemy)
	else:
		print("Fehler: enemy_scene ist nicht gesetzt!")

func StartSpawning(spawnCountRef : float):
	for i in range(spawnCountRef):
		print("SPawnt")
		var currentPos = get_random_position()
		spawn_enemy(currentPos,enemy_10hp)
	

func get_random_position() -> Vector2:
	
	var polygon = $CollisionPolygon2D.polygon  # Zugriff auf das Polygon-Array
	
	if polygon.is_empty():
		return global_position  # Falls das Polygon leer ist, Rückgabe der aktuellen Position
	
	# Berechne die Begrenzung (AABB - Axis-Aligned Bounding Box)
	var rect = Rect2()
	for point in polygon:
		rect = rect.expand(point)
	
	var min_x = global_position.x + rect.position.x
	var min_y = global_position.y + rect.position.y

	return Vector2(
		randf_range(min_x, min_x + rect.size.x), 
		randf_range(min_y, min_y + rect.size.y)
	)
