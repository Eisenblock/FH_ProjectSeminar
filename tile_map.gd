extends TileMap

@export var ENEMY_SCENE : PackedScene
const MAP_WIDTH = 90
const MAP_HEIGHT = 90

const FLOOR_ATLAS = Vector2i(3, 3)  # Atlas-Koordinaten für Boden
const WALL_ATLAS = Vector2i(3, 14)  # Atlas-Koordinaten für Wand

var map = []  # 2D-Array für Dungeon-Daten
var rooms = []

func _ready():
	generate_map()
	place_tiles()
	spawn_enemies()

func generate_map():
	# 1. Map mit Wänden füllen
	map = []
	for y in range(MAP_HEIGHT):
		map.append([])
		for x in range(MAP_WIDTH):
			map[y].append(WALL_ATLAS)  # Standardmäßig Wand

	# 2. Räume generieren
	rooms = []  # Liste, um die Raum-Positionen zu speichern
	for i in range(10):  # Anzahl der Räume
		var room_w = randi_range(5, 20)
		var room_h = randi_range(5, 20)
		var room_x = randi_range(1, MAP_WIDTH - room_w - 1)
		var room_y = randi_range(1, MAP_HEIGHT - room_h - 1)

		# Raum hinzufügen
		rooms.append(Rect2(room_x, room_y, room_w, room_h))

		# Räume in der Map eintragen
		for y in range(room_y, room_y + room_h):
			for x in range(room_x, room_x + room_w):
				map[y][x] = FLOOR_ATLAS  # Räume mit Boden füllen

	# 3. Korridore zwischen den Räumen erstellen
	for i in range(rooms.size() - 1):
		var room1 = rooms[i]
		var room2 = rooms[i + 1]
		
		# Wähle zufällige Punkte in beiden Räumen
		var start = Vector2(randi_range(room1.position.x, room1.position.x + room1.size.x - 1),
							randi_range(room1.position.y, room1.position.y + room1.size.y - 1))
		var end = Vector2(randi_range(room2.position.x, room2.position.x + room2.size.x - 1),
						  randi_range(room2.position.y, room2.position.y + room2.size.y - 1))
		var pos = get_random_floor_position(room1)
		var world_position = map_to_local(pos)  
		# Verbinde die Räume mit einem Korridor
		create_corridor(start, end)


func generate_wall_collisions():
	var tile_size = Vector2(tile_set.tile_size)
	var collision_polygon = CollisionPolygon2D.new()
	var walls = PackedVector2Array()
	
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if map[y][x] == WALL_ATLAS:  # Falls es eine Wand ist
				var world_pos = map_to_local(Vector2(x, y))
				
				# Viereck für die Kollision erstellen
				var top_left = world_pos
				var top_right = world_pos + Vector2(tile_size.x, 0)
				var bottom_right = world_pos + tile_size
				var bottom_left = world_pos + Vector2(0, tile_size.y)

				# Punkte zur Liste hinzufügen
				walls.append(top_left)
				walls.append(top_right)
				walls.append(bottom_right)
				walls.append(bottom_left)
	
	# Falls Wände existieren, zur NavigationRegion hinzufügen
	if walls.size() > 0:
		collision_polygon.polygon = walls
		$"../NavigationRegion2D".add_child(collision_polygon)
# Funktion, um einen Korridor zwischen zwei Punkten zu erstellen (mit einer Breite von 2)
func create_corridor(start: Vector2, end: Vector2):
	var current = start
	while current != end:
		if current.x < end.x:
			current.x += 1
		elif current.x > end.x:
			current.x -= 1

		if current.y < end.y:
			current.y += 1
		elif current.y > end.y:
			current.y -= 1

		# Setze Kacheln für den Korridor auf Boden (FLOOR_ATLAS)
		# Machen wir den Korridor 2 Kacheln breit
		for y_offset in range(-1, 2):  # Setze 2 Kacheln vertikal
			for x_offset in range(-1, 2):  # Setze 2 Kacheln horizontal
				var x_pos = int(current.x) + x_offset
				var y_pos = int(current.y) + y_offset
				if x_pos >= 0 and x_pos < MAP_WIDTH and y_pos >= 0 and y_pos < MAP_HEIGHT:
					map[y_pos][x_pos] = FLOOR_ATLAS

# Funktion, um die Map in die TileMap zu übertragen
func place_tiles():
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			set_cell(0,Vector2i(x, y), 0, map[y][x])  # Korrigiert: set_cell erwartet einen Vector2i für die Position
	#generate_navigation()


func spawn_enemies():
	var used_positions = []  # Liste der bereits verwendeten Positionen
	for room in rooms:
		# Berechne die Anzahl der Gegner basierend auf der Raumgröße
		var room_area = room.size.x * room.size.y  # Raumfläche
		var enemy_count = randi_range(1, max(1, int(room_area / 6)))  # Anzahl der Gegner (Skalierung basierend auf der Raumgröße)

		for a in range(enemy_count):
			var enemy_spawned = false  # Flag, um zu überprüfen, ob ein Gegner erfolgreich gespawnt wurde

			# Versuche, einen Gegner zu spawnen, ohne doppelte Positionen
			while not enemy_spawned:
				var start = get_random_floor_position(room)
				# Stelle sicher, dass die Position ein Boden ist und noch nicht verwendet wurde
				if is_floor_tile(start) and not used_positions.has(Vector2(start)):
					spawn_enemy(start)  # Gegner an dieser Position spawnen
					used_positions.append(start)  # Füge die Position der Liste hinzu
					print("Enemy spawned at: ", start)  # Debugging
					enemy_spawned = true  # Gegner wurde erfolgreich gespawnt

# Überprüfe, ob die Tile an der angegebenen Position Boden ist
func is_floor_tile(pos: Vector2) -> bool:
	if pos.x >= 0 and pos.x < MAP_WIDTH and pos.y >= 0 and pos.y < MAP_HEIGHT:
		return map[pos.y][pos.x] == FLOOR_ATLAS  # Boden ist als `FLOOR_ATLAS` definiert
	return false

# Gegner instanziieren
func spawn_enemy(position: Vector2):
	var enemy = ENEMY_SCENE.instantiate()  

	# Falls `map_to_local(position)` zu groß ist, versuche es manuell:
	var tile_size = Vector2(16, 16)  # Falls deine Tiles 32x32 Pixel groß sind
	var world_position = position * tile_size  

	enemy.position = world_position
	add_child(enemy)  

	print("Enemy TILE coords:", position)
	print("Enemy WORLD coords:", world_position)


func get_random_floor_position(room: Rect2) -> Vector2:
	var pos
	while true:
		pos = Vector2i(
			int(room.position.x) + randi_range(0, int(room.size.x) - 1),
			int(room.position.y) + randi_range(0, int(room.size.y) - 1)
		)
		if is_floor_tile(pos):  # Stelle sicher, dass es ein Boden-Tile ist
			break
	return pos

func generate_navigation():
	var nav_polygon = NavigationPolygon.new()
	var polygon = PackedVector2Array()  # Liste aller Navigationspunkte
	
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if map[y][x] == FLOOR_ATLAS:  # Falls es Boden ist
				var world_pos = map_to_local(Vector2(x, y))  # Tile-Koordinate zu Welt-Koordinate
				var tile_size = Vector2(tile_set.tile_size)  # Konvertiere `Vector2i` zu `Vector2`
				
				# Erstelle ein Viereck für die Navigation
				var top_left = world_pos
				var top_right = world_pos + Vector2(tile_size.x, 0)  # Konvertierung beachten!
				var bottom_right = world_pos + tile_size
				var bottom_left = world_pos + Vector2(0, tile_size.y)
				
				# Füge das Viereck hinzu (Reihenfolge: gegen den Uhrzeigersinn)
				polygon.append(top_left)
				polygon.append(top_right)
				polygon.append(bottom_right)
				polygon.append(bottom_left)

	# Setze das Polygon in die NavigationRegion2D
	nav_polygon.add_outline(polygon)
	nav_polygon.make_polygons_from_outlines()
	
	$"../NavigationRegion2D".navigation_polygon = nav_polygon  
