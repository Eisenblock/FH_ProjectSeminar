extends Node2D

@onready var bombZone: CollisionPolygon2D = $"../Bomb_Zone/CollisionPolygon2D"
@onready var spawnTimer: Timer = $Timer
var bomb: PackedScene = load("res://bomb_zone_feed_back.tscn")
var bombList : Array = []
var bombs_to_spawn := 10

func _ready() -> void:
	spawnTimer = Timer.new()
	spawnTimer.wait_time = 5
	spawnTimer.one_shot = false
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	spawnTimer.start()

func _on_spawnTimer_timeout() -> void:
	for bomb in range(bombs_to_spawn):
		spawn_bomb()


func spawn_bomb() -> void:
	var bomb_instance = bomb.instantiate()
	var bomb_pos = get_random_valid_position(bombZone, bombList, 30)
	bomb_instance.global_position = bomb_pos
	bombList.append(bomb_instance.global_position)
	get_parent().add_child(bomb_instance)

func get_random_valid_position(polygon: CollisionPolygon2D, bomb_list: Array, min_distance := 40.0, max_tries := 100) -> Vector2:
	var global_points = []
	for p in polygon.polygon:
		global_points.append(polygon.to_global(p))

	# Bounding-Box berechnen, um innerhalb dieser Punkte zu testen
	var points = get_polygon_global_points(polygon)
	var bounds = get_bounds_from_global_points(points)
	for i in max_tries:
		var x = randf_range(bounds.position.x, bounds.position.x + bounds.size.x)
		var y = randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
		var candidate = Vector2(x, y)

		# ✅ Prüfen: Liegt der Punkt im echten Polygon?
		if Geometry2D.is_point_in_polygon(candidate, global_points):
			var too_close = false
			for bomb in bomb_list:
				if bomb.distance_to(candidate) < min_distance:
					too_close = true
					break
			if not too_close:
				return candidate

	# ❌ Kein gültiger Punkt gefunden
	return polygon.to_global(Vector2.ZERO)

func get_polygon_global_points(polygon: CollisionPolygon2D) -> Array:
	var global_points: Array = []
	for p in polygon.polygon:
		global_points.append(polygon.to_global(p))
	return global_points

func get_bounds_from_global_points(global_points: Array) -> Rect2:


	var min_x = global_points[0].x
	var max_x = global_points[0].x
	var min_y = global_points[0].y
	var max_y = global_points[0].y

	for p in global_points:
		min_x = min(min_x, p.x)
		max_x = max(max_x, p.x)
		min_y = min(min_y, p.y)
		max_y = max(max_y, p.y)

	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
