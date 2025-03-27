extends CharacterBody2D

@export var normalShoot : NodePath
@export var normalShootScene : PackedScene
@export var normalShootScene2 : PackedScene
@export var fireShootScene : PackedScene
@export var circleShootScene : PackedScene
@export var speed = 200
@export var attackSpeed = 3.0
@export var health = 20
@export var max_health = 20
@onready var node_2d: Node2D = $"../Camera2D/Node2D"
@onready var healthBar: ProgressBar = $ProgressBar
@onready var camera_2d: Camera2D = $Camera2D

#Spell Active Bool
var fireBall : bool = false 
var circleBall : bool = false
var attack_method: Callable

var autoShootonCD : bool = false
var timerautoShoot : Timer
var circleShootonCD : bool = false
var timercirleShoot : Timer

var projectileAmount = 1
var countProjectile = 0

func _ready() -> void:
	if healthBar :
		healthBar.max_value = max_health
		healthBar.value = health

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()  # Verhindert schnellere diagonale Bewegung

	velocity = direction * speed
	move_and_slide()
	

func _process(delta: float) -> void:
	
	ActivateAbilityAttr()
	
	if fireBall and !autoShootonCD:
		spawnAutoShoot()
		StartAttacksRef(normalShootScene2,Global.autoShootAttribute,Callable(self, "spawnAutoShoot"))
	
	if circleBall and !circleShootonCD:
		StartAttacksRef(circleShootScene,Global.circleShootAttribute,Callable(self, "spawnCircleShoot"))
	
	if healthBar :
		healthBar.value = health
	#camera_2d.position = global_position

func spawnCircleShoot() :  
	"""
	if Global.circleShootAttributeAttribute.has("more_projectiles") :
		countProjectile = 0
		var size = Global.circleShootAttributeAttribute["more_projectiles"] + projectileAmount
		print("CUrrent Size",size)
		for countProjectile in range(size):  # range(3) geht von 0 bis 2, also insgesamt 3 Durchläufe
			var instance = circleShootScene.instantiate()
			if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				instance.position = global_position 
				instance.SetProjectile(Global.circleShootAttributeAttribute)
				get_tree().root.add_child(instance)
			await get_tree().create_timer(0.3).timeout
	else :"""
	var instance = circleShootScene.instantiate()
	if instance != null :
			var direction = (get_global_mouse_position() - global_position).normalized()
			instance.position = global_position 
			instance.SetProjectile(Global.autoShootAttribute)
			get_tree().root.add_child(instance)

func spawnAutoShoot():
	var instance
	"""
	if Global.autoShootAttribute.has("more_projectiles") :
		countProjectile = 0
		var size = Global.autoShootAttribute["more_projectiles"] + projectileAmount
		print("CUrrent Size",size)
		for countProjectile in range(size):  # range(3) geht von 0 bis 2, also insgesamt 3 Durchläufe
			instance = normalShootScene.instantiate()
			if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				var angle_to_mouse = direction.angle()
				instance.rotation = angle_to_mouse + deg_to_rad(-90) 
				instance.position = global_position 
				#var a = get_node(normalShoot)
				instance.SetProjectile(Global.autoShootAttribute)
				get_tree().root.add_child(instance)
				await get_tree().create_timer(0.2).timeout
	else :"""
	instance = normalShootScene2.instantiate()
	if instance != null :
			var direction = (get_global_mouse_position() - global_position).normalized()
			var angle_to_mouse = direction.angle()
			instance.rotation = angle_to_mouse + deg_to_rad(-90) 
			instance.position = global_position 
			#var a = get_node(normalShoot)
			#instance.SetProjectile(Global.ChestAttribute)
			get_tree().root.add_child(instance)


func _on_button_pressed() -> void:
	pass # Replace with function body.

func take_damage(amount) :
	health -= amount
	#print("Lost Health: %s" % health)

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
	if Global.ChestAttribute.has("Fireball") and !autoShootonCD:
		fireBall = true
	if Global.ChestAttribute.has("Circleball") and !circleShootonCD :
		circleBall = true


func StartAttacksRef(shotSceneRef: PackedScene, dicRef: Dictionary, attack_method_param: Callable):
	attack_method = attack_method_param  # Speichere die übergebene Methode
	var timerRef = null
	timerRef = Timer.new()
	add_child(timerRef)
	if dicRef.has("attack_speed"):
		var temp_instance = shotSceneRef.instantiate()
		var cast_time = temp_instance.castTime
		temp_instance.queue_free() 
	else :
		var temp_instance = shotSceneRef.instantiate()
		var cast_time = temp_instance.castTime
		temp_instance.queue_free()
		timerRef.wait_time = cast_time 
	timerRef.one_shot = false
	timerRef.connect("timeout", self.attack_method)
	timerRef.start()
	
	if circleBall and !circleShootonCD:
		circleShootonCD = true
		timercirleShoot = timerRef 
	if fireBall and !autoShootonCD:
		autoShootonCD = true
		timerautoShoot = timerRef 
