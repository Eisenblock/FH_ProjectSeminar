extends Area2D

@export var autoShoot : bool = false
@export var autoShootBase : bool = false
@export var player : CharacterBody2D
@export var CircleBall_bool : bool = false
@export var FireBall_bool : bool = false
@export var DarkBall_bool : bool = false
@export var Bumerang : bool = false
@export var ChainLightning : bool = false
@export var explodeScene : PackedScene
@export var distance : float = 100.0  # Der Abstand des Objekts vom Player
@export var castTime: float = 2
@export var tilemap: TileMap 
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explode: CollisionShape2D = $Explode
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var max_chains = 3
var startShapeCOllider = 0
var startSizeEffect = 0
var lastPosEnemy = 0
var already_hit = []
var current_target = null
var chain_count = 0
var is_sprite_freed = false 
var countenemyHits = 0
var direction = 0
var timerResetForward : Timer 
var timerGotHit : Timer
var timerLifeTime : Timer
var angle : float = 0.0  # Aktueller Winkel des Objekts
var player_node : Node2D
var elapsed_time = 0.0
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
	"""startShapeCOllider = $CollisionShape2D.shape.duplicate()
	startShapeCOllider.extents.x = 10  # Für eine Breite von 20
	startShapeCOllider.extents.y = 10  # Für eine Höhe von 20
	$CollisionShape2D.shape = startShapeCOllider
	startSizeEffect = $Sprite2D.scale.x
	lastPosEnemy = global_position"""
	if Bumerang :
		timerResetForward = Timer.new()
		add_child(timerResetForward)
		timerResetForward.wait_time = lifetime/2
		timerResetForward.one_shot = false
		timerResetForward.connect("timeout", self.ResetMovementNegativ)
		timerResetForward.start()
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
	elapsed_time += delta
	if autoShoot and !CircleBall_bool and !ChainLightning :
		position += direction * speed *delta
	else :
		pass#position += direction * speed *delta
	# Berechne den neuen Winkel basierend auf der Zeit und der Geschwindigkeit
	if DarkBall_bool : 
		position += direction * speed *delta
	if Bumerang :
		position += direction * speed *delta
		if elapsed_time >= lifetime / 2:
			direction = (player_node.global_position - global_position).normalized()
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
func ResetMovementNegativ():
	direction = (player_node.global_position - global_position).normalized()

func _process(delta: float) -> void:
	#compareAttributes()
	if animated_sprite_2d :
		animated_sprite_2d.play("fly")
	if ChainLightning :
		#$Sprite2D.scale.y = 2.0 
		#$Sprite2D.scale.x += 0.2 
		current_target = find_next_target()
		DoChainLightning(current_target)


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
	print("hittttt")
	if area.is_in_group("Wall") and !CircleBall_bool :
		queue_free()
	if area.is_in_group("enemy") :
		#print("Hit Enemy")
		if FireBall_bool :
			var instance = explodeScene.instantiate()
			instance.position = global_position
			get_tree().root.add_child(instance)
			queue_free()
		if autoShoot or CircleBall_bool :
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
		if DarkBall_bool :
			timerGotHit = Timer.new()
			add_child(timerGotHit)
			timerGotHit.wait_time = 1 
			timerGotHit.one_shot = false
			timerGotHit.connect("timeout", self.resetGotHit)
			timerGotHit.start()
			var enemy = area.get_parent()
			countenemyHits += 1;
			enemy.take_damage(dmg)
			if countenemyHits == 2: 
				queue_free()
		if Bumerang :
			var enemy = area.get_parent()
			enemy.take_damage(dmg)
		if ChainLightning :
			timerGotHit = Timer.new()
			add_child(timerGotHit)
			timerGotHit.wait_time = 1 
			timerGotHit.one_shot = false
			timerGotHit.connect("timeout", self.resetGotHit)
			timerGotHit.start()
			var enemy = area.get_parent()
			enemy.take_damage(dmg)
			lastPosEnemy = enemy.global_position
			already_hit.append(enemy)
			$Sprite2D.global_position = lastPosEnemy
			current_target = find_next_target()
			startShapeCOllider.extents.x = 10  # Für eine Breite von 20
			startShapeCOllider.extents.y = 10  # Für eine Höhe von 20
			$CollisionShape2D.shape = startShapeCOllider
			$Sprite2D.scale.x = startSizeEffect
			chain_count += 1
			if chain_count == 3: 
				$CollisionShape2D.shape = startShapeCOllider
				$Sprite2D.scale.x = startSizeEffect
				queue_free()

func resetGotHit():
	pass

func DestroySelf():
	queue_free()

func compareAttributes():
	
	if !areDictionariesEqual(attributes, Global.autoShootAttribute):
		#print("Die Dictionaries sind unterschiedlich. Methode wird ausgeführt.")
		attributes = Global.autoShootAttribute
		SetAttributes()
		print_all_attributes()

func areDictionariesEqual(dict1: Dictionary, dict2: Dictionary) -> bool:
	return dict1 == dict2

func getPlayer():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Ersten Spieler aus der Gruppe setzen
	

func SetDirection(direction_ref):
	direction = direction_ref

func hit_target():
	# Schaden machen
	#current_target.take_damage(10)
	already_hit.append(current_target)
	chain_count += 1

	if chain_count >= max_chains:
		queue_free()
		return

	var next_target = find_next_target()
	if next_target:
		current_target = next_target
	else:
		queue_free()

func find_next_target():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest = null
	var min_dist = 300
	for enemy in enemies:
		if enemy in already_hit:
			continue
		var dist = global_position.distance_to(enemy.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = enemy
	return closest


func DoChainLightning(current_target):
	# Finde den nächsten Ziel-Gegner
	if current_target == null:
		queue_free()
	else :
		# Berechne die Richtung vom aktuellen Punkt (Player) zum Ziel
		var dir = (current_target.global_position - lastPosEnemy).normalized()
		direction = dir
		rotation = dir.angle()  # Dreht den Strahl zum Gegner

		# Berechne die Entfernung (die Länge des Strahls)
		var distance = dir.length()

		# Dein Sprite2D, das den Strahl darstellt
		var sprite = sprite_2d
		if sprite == null:
			print("Das Sprite existiert nicht mehr.")
			return
		# Hole die Breite der Textur des Strahls
		var texture_width = sprite_2d.texture.get_width()
		#print(texture_width)
		# Skalierung des Strahls auf Basis der Entfernung
		$CollisionShape2D.shape.extents.x += (distance / 2) * 4
		$Sprite2D.scale.x += (distance / texture_width) * 4
		# Setze die Position des Strahls, sodass er an der richtigen Stelle startet
		$Sprite2D.global_position = lastPosEnemy
		lastPosEnemy += (dir * 30.0 * get_process_delta_time()) * 4
		
		# Optional: Setze die Position des Strahls zum Ziel hin, indem du die Mitte anpasst
		# Damit der Strahl immer genau zwischen dem Player und dem Target ist
		position = lastPosEnemy + dir * (distance / 2) # Position in der Mitte des Strahls

	# Optional: Verstecke den Strahl nach kurzer Zeit (z.B. 0.2 Sekunden)
	"""var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	add_child(timer)
	timer.start()

	timer.timeout.connect(func():
		if !is_sprite_freed and sprite != null:
			sprite.queue_free()  # Lösche das Sprite nach der Zeit
			is_sprite_freed = true  # Markiere das Sprite als freigegeben
		timer.queue_free()  # Lösche den Timer
		)
"""
