extends CharacterBody2D
var health : float = 4000
var start_health = 0
var timerBeam = 0
var timerBombs = 0
var intervall_bomb = 5
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar_life: ProgressBar = $ProgressBarLife
@onready var bombZone: CollisionPolygon2D = $"../Bomb_Zone/CollisionPolygon2D"
var DmgText = load("res://UI/dmg_text.tscn")
var spawnTimer: Timer 
var resetTimerColor : Timer
var deathTimer : Timer
var shotTimer : Timer
var bomb: PackedScene = load("res://bomb_zone_feed_back.tscn")
var bombList : Array = []
var bombs_to_spawn := 20
var spawn_Values = [3,2]
var Shot_Boss: PackedScene = load("res://NichtSortiert/enemyBoss_ProjectileScene.tscn")
var beam: PackedScene = load("res://spin_beam.tscn")
var isDead = false
var isEnrage = false
var Stage_I = false
var isImmun = true
var gotCrit = false
var allMove_tilemaps = null
var allBlock_tilemaps = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allMove_tilemaps = get_tree().get_nodes_in_group("TileMap_Move")
	allBlock_tilemaps = get_tree().get_nodes_in_group("BlockedField")
	health = health + Global.bosslifeIncrease
	start_health = health
	if progress_bar_life :
		progress_bar_life.max_value = start_health
		progress_bar_life.value = health


func _process(delta: float) -> void:
	progress_bar_life.value = health
	if animated_sprite_2d and !isEnrage and !Stage_I:
		animated_sprite_2d.play("idle")
	if animated_sprite_2d and !isEnrage and Stage_I :
		animated_sprite_2d.play("Stage_I")
	if animated_sprite_2d and isEnrage and !isDead:
		animated_sprite_2d.play("enrage")
	if animated_sprite_2d and isEnrage and isDead:
		animated_sprite_2d.play("dead")
	if (start_health /4) * 3 > health and !Stage_I:
		First_Stage()
	if (start_health /3) * 1 > health and !isEnrage:
		Enrage()
func _on_spawnTimer_timeout() -> void:
	for bomb in range(bombs_to_spawn):
		spawn_bomb()


func spawn_bomb() -> void:
	var bomb_instance = bomb.instantiate()
	var bomb_pos = get_random_valid_position(bombZone, bombList,20, 50)
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

func take_damage(amount):
	if !isImmun :
		health -= amount 
		animated_sprite_2d.self_modulate = Color.RED
		resetTimerColor = Timer.new()
		resetTimerColor.wait_time = 0.3
		resetTimerColor.one_shot = true
		resetTimerColor.connect("timeout", Callable(self, "ResetColor"))
		if resetTimerColor and resetTimerColor.get_parent() == null:
			add_child(resetTimerColor)
		resetTimerColor.start()
		var dmgText = DmgText.instantiate()
		if gotCrit :
			dmgText.modulate = Color("ffff3b")
			gotCrit = false
		get_tree().root.add_child(dmgText)
		dmgText.dmg_value = amount
		dmgText.position = self.global_position #Vector2(5,-40)
		if health <= 0 :
			var beam = get_tree().get_first_node_in_group("Beam")
			beam.queue_free()
			deathTimer = Timer.new()
			deathTimer.wait_time = 1.5
			deathTimer.one_shot = true 
			deathTimer.connect("timeout", Callable(self, "DoDeath"))
			add_child(deathTimer)
			for object in allMove_tilemaps :
				object.ResetMovement()
			for object in allBlock_tilemaps:
				object.set_layer_enabled(0, false)
			deathTimer.start()
			isDead = true 


func ResetColor():
	animated_sprite_2d.self_modulate = Color.WHITE

func DoDeath():
	Global.bosslifeIncrease += 2000
	queue_free()

func Enrage():
	Stage_I = false
	spawnTimer.stop()
	bombs_to_spawn = 30
	spawnTimer.wait_time = spawn_Values[0]
	spawnTimer.one_shot = false
	isEnrage = true
	spawnTimer.start()

func GotCritTrue():
	gotCrit = true

func SpawnShot():
	var shot_instance = Shot_Boss.instantiate()
	shot_instance.position = self.global_position
	get_parent().add_child(shot_instance)

func StartBossFight():
	isImmun = false
	var beam_instance = beam.instantiate()
	beam_instance.position = self.global_position
	get_parent().add_child(beam_instance)
	shotTimer = Timer.new()
	shotTimer.wait_time = 2 
	shotTimer.one_shot = false 
	shotTimer.connect("timeout", Callable(self, "SpawnShot"))
	add_child(shotTimer)
	shotTimer.start()

func First_Stage():
	Stage_I = true
	spawnTimer = Timer.new()
	spawnTimer.wait_time = spawn_Values[0]
	spawnTimer.one_shot = false
	spawnTimer.connect("timeout", Callable(self, "_on_spawnTimer_timeout"))
	add_child(spawnTimer)
	spawnTimer.start()
