extends Area2D

@export var enemy_scene: PackedScene 
var enemyCount = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Global.enemySpawnCount):
		print("SPawnt")
		var currentPos = get_random_position()
		spawn_enemy(currentPos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(pos : Vector2):
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.position = pos  # Spawnt am Ort von Area2D
		add_child(enemy)  # Fügt den Gegner zur Szene hinzu
		Global.enemyList.append(enemy)
	else:
		print("Fehler: enemy_scene ist nicht gesetzt!")

func StartSpawning(spawnCountRef : float):
	for i in range(spawnCountRef):
		print("SPawnt")
		var currentPos = get_random_position()
		spawn_enemy(currentPos)

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
