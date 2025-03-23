extends CharacterBody2D

@export var normalShoot : NodePath
@export var normalShootScene : PackedScene
@export var circleShootScene : PackedScene
@export var speed = 200
@export var attackSpeed = 3.0
@export var health = 20
@export var max_health = 20
@onready var node_2d: Node2D = $"../Camera2D/Node2D"
@onready var healthBar: ProgressBar = $ProgressBar
@onready var camera_2d: Camera2D = $"../Camera2D"


var autoShootonCD : bool = false
var timerautoShoot : Timer
var circleShootonCD : bool = false
var timercirleShoot : Timer

var projectileAmount = 1
var countProjectile = 0

func _ready() -> void:
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
	if Input.is_action_just_pressed("Shoot") and !autoShootonCD:
		spawnAutoShoot()
		autoShootonCD = true
		timerautoShoot = Timer.new()
		add_child(timerautoShoot)
		if Global.autoShootAttribute.has("attack_speed") :
			var temp_instance = normalShootScene.instantiate()
			var cast_time = temp_instance.castTime
			temp_instance.queue_free()
			timerautoShoot.wait_time = cast_time  - Global.autoShootAttribute["attack_speed"] 
		else :
			var temp_instance = normalShootScene.instantiate()
			var cast_time = temp_instance.castTime
			temp_instance.queue_free()
			timerautoShoot.wait_time = cast_time 
		timerautoShoot.one_shot = false
		timerautoShoot.connect("timeout", self.spawnAutoShoot)
		timerautoShoot.start()
	
	if Input.is_action_just_pressed("Shoot2") and !circleShootonCD:
		circleShootonCD = true
		timercirleShoot = Timer.new()
		add_child(timercirleShoot)
		if Global.circleShootAttribute.has("attack_speed"):
			var temp_instance =	circleShootScene.instantiate()
			var cast_time = temp_instance.castTime
			temp_instance.queue_free() 
		else :
			var temp_instance =	circleShootScene.instantiate()
			var cast_time = temp_instance.castTime
			temp_instance.queue_free()
			timercirleShoot.wait_time = cast_time 
		timercirleShoot.one_shot = false
		timercirleShoot.connect("timeout", self.spawnCircleShoot)
		timercirleShoot.start()
	
	healthBar.value = health
	camera_2d.position = global_position

func spawnCircleShoot() :  
	
	if Global.circleShootAttribute.has("more_projectiles") :
		countProjectile = 0
		var size = Global.circleShootAttribute["more_projectiles"] + projectileAmount
		print("CUrrent Size",size)
		for countProjectile in range(size):  # range(3) geht von 0 bis 2, also insgesamt 3 Durchläufe
			var instance = circleShootScene.instantiate()
			if instance != null :
				var direction = (get_global_mouse_position() - global_position).normalized()
				instance.position = global_position 
				instance.SetProjectile(Global.circleShootAttribute)
				get_tree().root.add_child(instance)
			await get_tree().create_timer(0.3).timeout
	else :
		var instance = circleShootScene.instantiate()
		if instance != null :
			var direction = (get_global_mouse_position() - global_position).normalized()
			instance.position = global_position 
			instance.SetProjectile(Global.circleShootAttribute)
			get_tree().root.add_child(instance)

func spawnAutoShoot():
	var instance
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
	else :
		instance = normalShootScene.instantiate()
		if instance != null :
			var direction = (get_global_mouse_position() - global_position).normalized()
			var angle_to_mouse = direction.angle()
			instance.rotation = angle_to_mouse + deg_to_rad(-90) 
			instance.position = global_position 
			#var a = get_node(normalShoot)
			instance.SetProjectile(Global.autoShootAttribute)
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
