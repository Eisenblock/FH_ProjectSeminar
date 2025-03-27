extends CharacterBody2D

@export var speed = 100
@export var dmg = 10
@export var health = 10
@export var aggroRange = 50
@export var hitRange = 20

var timerGotHit : Timer
var timerResetTakeDamage : Timer
var gotTriggered : bool = false
var targetPLayer : CharacterBody2D
var accel = 7
var direction = Vector3()

var gotHit : bool = false
var isDead :bool = false

@onready var nav: NavigationAgent2D = $NavigationAgent2D




func _ready() -> void:
	getPlayer()

func _process(delta: float) -> void:
	if targetPLayer == null:
		return
	if aggroRange >= global_position.distance_to(targetPLayer.global_position):
		gotTriggered = true
	
	if gotTriggered == true :
		nav.target_position = targetPLayer.global_position
		if  !gotHit :
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
		if gotHit:
			direction = (targetPLayer.global_position - global_position).normalized()
			direction *= -1  # Richtung umkehren
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
		
		_check_distance()

func _physics_process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		body.take_damage(1)
	



func getPlayer():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		targetPLayer = players[0]  # Ersten Spieler aus der Gruppe setzen
	
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") :
		timerGotHit = Timer.new()
		add_child(timerGotHit)
		timerGotHit.wait_time = 1 
		timerGotHit.one_shot = false
		#timerGotHit.connect("timeout", self.resetGotHit)
		#timerGotHit.start()
		var player = area.get_parent()
		player.take_damage(1)
		#gotHit = true

func resetGotHit():
	timerGotHit.queue_free()
	gotHit = false

func take_damage(amount) :
	gotTriggered = true
	health -= amount
	self.modulate = Color("ec0006")
	#print("Lost Health Enemy: %s" % health)
	timerResetTakeDamage = Timer.new()
	add_child(timerResetTakeDamage)
	timerResetTakeDamage.wait_time = 0.4
	timerResetTakeDamage.one_shot = true
	timerResetTakeDamage.connect("timeout", self.ResetModular)
	timerResetTakeDamage.start()
	if health <= 0 :
		isDead = true
		Global.enemyList.erase(self)
		queue_free()

func _check_distance():
	for enemy in Global.enemyList:
		if enemy != self and !isDead and enemy != null:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < 10:
				_adjust_position(distance, enemy)

# Funktion, um die Position des Gegners anzupassen
func _adjust_position(distance, other_enemy):
	
	var direction = (global_position - other_enemy.global_position).normalized()
	
	
	global_position = other_enemy.global_position + direction * 10


func ResetModular():
	self.modulate = Color("ffffff")
