extends CharacterBody2D

var spawnUI 
@export var normalShoot : NodePath
@export var normalShootScene : PackedScene
@export var normalShootScene2 : PackedScene
@export var fireShootScene : PackedScene
@export var circleShootScene : PackedScene
@export var DarkShootScene : PackedScene
@export var BumerangShootScene : PackedScene
@export var speed = 200
@export var attackSpeed = 3.0
@export var health = 20
@export var armor = 0
@export var life_reg = 0.0
@export var max_health = 20
@onready var node_2d: Node2D = $"../Camera2D/Node2D"
@onready var healthBar: ProgressBar = $ProgressBar
@onready var camera_2d: Camera2D = $Camera2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#Spell Active Bool
var fireBall : bool = false 
var circleBall : bool = false
var darkBall : bool = false
var bumerang : bool = false
var attack_method: Callable

var autoShootonCD : bool = false
var timerautoShoot : Timer
var circleShootonCD : bool = false
var timercirleShoot : Timer
var fireShootonCD : bool = false
var timerfireShoot : Timer
var timerLifeReg : Timer 
var darkShootonCD : bool = false
var timerdarkShoot : Timer
var BumerangShootonCD : bool = false
var timerbumerangShoot : Timer
#var life_RegStarted_bool : bool = false
var dash_speed = 500
var dash_time = 0.2
var dash_cooldown = 1.0

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var projectileAmount = 1
var countProjectile = 0

func _ready() -> void:
	spawnUI = get_tree().get_first_node_in_group("spell_ui")
	load_abilities()
	UpdatePlayerAttr(Global.ChestAttribute)
	#StartAttacksRef(BumerangShootScene,Global.bumerangShootAttribute,Callable(self,"SpawnBumerangBall"),"bumerang")
	#StartAttacksRef(circleShootScene,Global.circleShootAttribute,Callable(self, "spawnCircleShoot"),"circle")
	
	#StartAttacksRef(DarkShootScene,Global.darkShootAttribute,Callable(self, "SPawnDarkBall"),"dark")
	if healthBar :
		healthBar.max_value = max_health
		healthBar.value = health
	#Start Life Reg
	timerLifeReg = Timer.new()
	timerLifeReg.wait_time = 1
	timerLifeReg.one_shot = false
	timerLifeReg.connect("timeout", self.DoLifeReg)
	add_child(timerLifeReg) 
	timerLifeReg.start()

func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	direction = direction.normalized()

	# Mausposition relativ zum Spieler
	var mouse_pos = get_global_mouse_position()
	var to_mouse = (mouse_pos - global_position).normalized()

	# Spieler flippen, wenn Maus links oder rechts ist
	animated_sprite_2d.flip_h = mouse_pos.x < global_position.x

	# Bewegung analysieren
	if direction != Vector2.ZERO:
		var angle_diff = direction.angle_to(to_mouse)

		if abs(angle_diff) < PI / 2:
			animated_sprite_2d.play("walk_front") # nach vorne zur Maus
		else:
			animated_sprite_2d.play("walk_back") # von Maus weg
	else:
		animated_sprite_2d.stop()
	# Dash starten
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != Vector2.ZERO:
		is_dashing = true
		dash_timer = dash_time
		dash_cooldown_timer = dash_cooldown
		velocity = direction * dash_speed
	else:
		# Normal bewegen, wenn nicht dashing
		if not is_dashing:
			velocity = direction * speed
	# Dash-Zeit läuft
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Cooldown runterzählen
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	move_and_slide()
	

func _process(delta: float) -> void:
	
	#ActivateAbilityAttr()
	if !autoShootonCD :
		StartAttacksRef(normalShootScene2,Global.autoShootAttribute,Callable(self, "ResetAttackTimerAuto"),"auto")
	
	if fireBall and !fireShootonCD:
		#spawnFireShoot()
		StartAttacksRef(fireShootScene,Global.fireballShootAttribute,Callable(self,"ResetAttackTimerFire"),"fire")
	
	if circleBall and !circleShootonCD:
		StartAttacksRef(circleShootScene,Global.circleShootAttribute,Callable(self, "ResetAttackTimerCircle"),"circle")
	
	if darkBall and !darkShootonCD:
		#SPawnDarkBall()
		StartAttacksRef(DarkShootScene,Global.darkShootAttribute,Callable(self,"ResetAttackTimerDark"),"dark")
	
	if bumerang and !BumerangShootonCD :
		#SpawnBumerangBall()
		StartAttacksRef(BumerangShootScene,Global.bumerangShootAttribute,Callable(self,"ResetAttackTimerBumerang"),"bumerang")
	
	if healthBar :
		healthBar.value = health
	#camera_2d.position = global_position

func spawnCircleShoot() :  
	
	if Global.circleShootAttribute.has("more_projectiles") :
		countProjectile = 0
		var size = Global.circleShootAttribute["more_projectiles"] + projectileAmount
		var radius = 75  # Abstand vom Zentrum (also von global_position)
		var angle_step = TAU / size  # TAU = 2*PI = voller Kreis
		
		for i in range(size):
			var instance = circleShootScene.instantiate()
			if instance != null:
				instance.angle = i * angle_step  # Individueller Startwinkel
				instance.distance = radius  # Optional
				instance.player_node = self  # oder übergeben
				get_tree().root.add_child(instance)
	else :
			var instance = circleShootScene.instantiate()
			if instance != null :
					var direction = (get_global_mouse_position() - global_position).normalized()
					instance.position = global_position 
					instance.SetProjectile(Global.circleShootAttribute)
					get_tree().root.add_child(instance)

func spawnAutoShoot():
	SpawnAllShots(normalShootScene,Global.autoShootAttribute)
	"""var instance
	
	if Global.autoShootAttribute.has("more_projectiles") :
		countProjectile = 0
		var size = Global.autoShootAttribute["more_projectiles"] + projectileAmount
		print("CUrrent Size",size)
		for countProjectile in range(size):  # range(3) geht von 0 bis 2, also insgesamt 3 Durchläufe
			instance = normalShootScene.instantiate()
			if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				var angle_to_mouse = direction.angle()
				instance.rotation = angle_to_mouse #+ deg_to_rad(-90) 
				instance.position = global_position 
				instance.SetDirection(direction)
				#var a = get_node(normalShoot)
				instance.SetProjectile(Global.autoShootAttribute)
				get_tree().root.add_child(instance)
				await get_tree().create_timer(0.2).timeout
	else :
		instance = normalShootScene2.instantiate()
		if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				var angle_to_mouse = direction.angle()
				instance.rotation = angle_to_mouse #+ deg_to_rad(-90) 
				instance.position = global_position 
				instance.SetDirection(direction)
				#var a = get_node(normalShoot)
				instance.SetProjectile(Global.autoShootAttribute)
				get_tree().root.add_child(instance)"""

func spawnFireShoot():
	SpawnAllShots(fireShootScene,Global.fireballShootAttribute)

func SPawnDarkBall():
	SpawnAllShots(DarkShootScene,Global.darkShootAttribute)

func SpawnBumerangBall():
	SpawnAllShots(BumerangShootScene,Global.bumerangShootAttribute)

func SpawnAllShots(sceneShot_ref : PackedScene , dic_ref : Dictionary ):
	var instance
	
	if dic_ref.has("more_projectiles") :
		countProjectile = 0
		var size = dic_ref["more_projectiles"] + projectileAmount
		var spread_degrees = 8  # Gesamtwinkel z. B. 30°
		var spread_radians = deg_to_rad(spread_degrees)
		var half_spread = spread_radians / 2
	
		for countProjectile in range(size):
			instance = sceneShot_ref.instantiate()
			if instance != null:
				var base_direction = (get_global_mouse_position() - global_position).normalized()
				var base_angle = base_direction.angle()
				
				# Verteile den Winkel gleichmäßig
				var t = 0.0
				if size > 1:
					t = float(countProjectile) / float(size - 1)  # 0.0 bis 1.0
				var offset_angle = lerp(-half_spread, half_spread, t)
				
				var final_angle = base_angle + offset_angle
				var adjusted_direction = Vector2(cos(final_angle), sin(final_angle))
				
				instance.rotation = final_angle
				instance.position = global_position
				instance.SetDirection(adjusted_direction)
				instance.SetProjectile(dic_ref)
				get_tree().root.add_child(instance)
				
	else :
		instance = sceneShot_ref.instantiate()
		if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				var angle_to_mouse = direction.angle()
				instance.rotation = angle_to_mouse #+ deg_to_rad(-90) 
				instance.position = global_position 
				instance.SetDirection(direction)
				#var a = get_node(normalShoot)
				instance.SetProjectile(dic_ref)
				get_tree().root.add_child(instance)

func _on_button_pressed() -> void:
	pass # Replace with function body.

func take_damage(amount) :
	health -= amount
	self.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	self.modulate = Color.WHITE
	if health <= 0:
		spawnUI.DoGameOver()


func resetCDAuto():
	autoShootonCD = false
	timerautoShoot.queue_free()

func resetCDCircle():
	circleShootonCD = false
	timercirleShoot.queue_free()

func resetCDs(timer_ref : Timer, value_bool : bool):
	value_bool = false
	timer_ref.queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func ActivateAbilityAttr():
	if Global.ChestAttribute.has("Fireball") and !fireShootonCD:
		fireBall = true
	if Global.ChestAttribute.has("Circleball") and !circleShootonCD :
		circleBall = true


func StartAttacksRef(shotSceneRef: PackedScene, dicRef: Dictionary, attack_method_param: Callable, nameAbility : String):
	attack_method = attack_method_param  # Speichere die übergebene Methode
	var timerRef = null
	timerRef = Timer.new()
	add_child(timerRef)
	if dicRef.has("attack_speed"):
		var temp_instance = shotSceneRef.instantiate()
		var cast_time = temp_instance.castTime - dicRef["attack_speed"]
		timerRef.wait_time = cast_time
		temp_instance.queue_free() 
	else :
		var temp_instance = shotSceneRef.instantiate()
		var cast_time = temp_instance.castTime
		#print(cast_time)
		temp_instance.queue_free()
		timerRef.wait_time = cast_time 
	timerRef.one_shot = true
	timerRef.connect("timeout", self.attack_method)
	timerRef.start()
	
	if nameAbility == "circle" and circleBall and !circleShootonCD:
		circleShootonCD = true
		timercirleShoot = timerRef 
		spawnCircleShoot()
	if nameAbility == "fire" and fireBall and !fireShootonCD:
		fireShootonCD = true
		timerfireShoot = timerRef 
		spawnFireShoot()
	if nameAbility == "auto" and  !autoShootonCD :
		autoShootonCD = true
		timerautoShoot = timerRef
		spawnAutoShoot()
	if nameAbility == "dark" and  !darkShootonCD:
		darkShootonCD = true
		timerdarkShoot = timerRef
		SPawnDarkBall()
	if nameAbility == "Bumerang" and !BumerangShootonCD :
		BumerangShootonCD = true
		timerbumerangShoot = timerRef
		SpawnBumerangBall()

func ResetAttackTimerAuto():
	autoShootonCD = false
func ResetAttackTimerDark():
	darkShootonCD = false
func ResetAttackTimerFire():
	fireShootonCD = false
func ResetAttackTimerBumerang():
	BumerangShootonCD = false
func ResetAttackTimerCircle():
	circleShootonCD = false

func UpdatePlayerAttr(dicRef : Dictionary):
	if "Health" in Global.ChestAttribute :
		health += Global.ChestAttribute["Health"]
	if "Armor" in Global.ChestAttribute :
		armor += Global.ChestAttribute["Armor"]
	if "Life_Reg" in Global.ChestAttribute:
		life_reg += Global.ChestAttribute["Life_Reg"]

func DoLifeReg():
	if health < max_health :
		health += life_reg

func load_abilities():
	if Global.learned_abilities.has("fireball"):
		fireBall = true
	if Global.learned_abilities.has("circleball"):
		circleBall = true
	if Global.learned_abilities.has("darkball"):
		darkBall = true
	if Global.learned_abilities.has("bumerang"):
		bumerang = true
