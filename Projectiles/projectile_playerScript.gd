extends Area2D

@export var autoShoot : bool = false
@export var autoShootBase : bool = false
@export var player : CharacterBody2D
@export var CircleBall_bool : bool = false
@export var FireBall_bool : bool = false
@export var explodeScene : PackedScene
@export var distance : float = 100.0  # Der Abstand des Objekts vom Player
@export var castTime: float = 2
@export var tilemap: TileMap 
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explode: CollisionShape2D = $Explode


var timerGotHit : Timer
var timerLifeTime : Timer
var angle : float = 0.0  # Aktueller Winkel des Objekts
var player_node : Node2D
#Attributes
@export var dmg = 5
var lifesteal_value = 0
var bonus_dmg_fireball = 0
@export var speed : float = 1.0 
@export var lifetime : float = 4.0
var i = 0

var fireball_bool : bool = false
var Explode_bool : bool = false
var attributes := {}

func _ready() -> void:
	collision_shape_2d.visible = true
	if explode :
		explode.disabled = true
	# Hole den Player-Node aus der Gruppe "players"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player_node = players[0] as Node2D  # Falls mehrere Spieler existieren, nimm den ersten
	else:
		print("Fehler: Kein Player in der Gruppe gefunden!")    
	getPlayer()
	if !autoShootBase :
		timerLifeTime = Timer.new()
		add_child(timerLifeTime)
		timerLifeTime.wait_time = lifetime
		timerLifeTime.one_shot = false
		timerLifeTime.connect("timeout", self.DestroySelf)
		timerLifeTime.start()
	


func _physics_process(delta: float) -> void:
	if autoShoot :
		position += Vector2.DOWN.rotated(rotation) * speed *delta
	# Berechne den neuen Winkel basierend auf der Zeit und der Geschwindigkeit
	if CircleBall_bool :
		angle += speed * delta  # Der Winkel ändert sich je nach Zeit (delta) und Geschwindigkeit

		# Stelle sicher, dass der Winkel immer zwischen 0 und 2 Pi bleibt
		angle = fmod(angle, 2 * PI)

		# Berechne die neue Position des Objekts, indem wir den Sinus und Kosinus des Winkels verwenden
		if player_node != null :
			var x = player_node.position.x + distance * cos(angle)  # X-Position im Kreis
			var y = player_node.position.y + distance * sin(angle)  # Y-Position im Kreis

		# Setze die Position des Objekts
			position = Vector2(x, y)
		
		#attributes = Global.autoShootAttribute
		#SetAttributes()
func _process(delta: float) -> void:
	#compareAttributes()
	pass

func SetAttributes():
	if "base_dmg" in attributes:
		dmg += attributes["base_dmg"]
	if "more_dmg_percent" in attributes:
		dmg = dmg + dmg * (attributes["more_dmg_percent"]/100)
	if "lifetime" in attributes :
		lifetime += attributes["lifetime"]
	if "lifesteal" in attributes :
		lifesteal_value += attributes["lifesteal"]
	#print_all_attributes()

func addAttribute(name :String , value : float):
	attributes[name] = value


func print_all_attributes() -> void:
	print("ALL Attr on Spell")
	for key in attributes.keys():
		print(key, ": ", attributes[key])

func SetProjectile(projetileattr := {} ):
	#var i = get_node(projetile)
	attributes = projetileattr
	print_all_attributes()
	SetAttributes()


func _on_area_entered(area: Area2D) -> void:
	if tilemap:
		var tile_pos = tilemap.local_to_map(global_position)  # Position des Projektils in Tile-Koordinaten
		var tile_data = tilemap.get_cell_tile_data(0, tile_pos)  # Prüft die erste Tile-Layer
		if tile_data and tile_data.get_collision_polygons_count(0) > 0:
			queue_free()  # Projektil zerstören
	if area.is_in_group("enemy") :
		print("Hit Enemy")
		if FireBall_bool :
			var instance = explodeScene.instantiate()
			instance.position = global_position
			get_tree().root.add_child(instance)
			queue_free()
		else :
			timerGotHit = Timer.new()
			add_child(timerGotHit)
			timerGotHit.wait_time = 1 
			timerGotHit.one_shot = false
			timerGotHit.connect("timeout", self.resetGotHit)
			timerGotHit.start()
			var enemy = area.get_parent()
			enemy.take_damage(dmg)
			if autoShoot :
				queue_free()


func resetGotHit():
	pass

func DestroySelf():
	queue_free()

func compareAttributes():
	
	if !areDictionariesEqual(attributes, Global.autoShootAttribute):
		print("Die Dictionaries sind unterschiedlich. Methode wird ausgeführt.")
		attributes = Global.autoShootAttribute
		SetAttributes()
		print_all_attributes()

func areDictionariesEqual(dict1: Dictionary, dict2: Dictionary) -> bool:
	return dict1 == dict2

func getPlayer():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Ersten Spieler aus der Gruppe setzen
	
