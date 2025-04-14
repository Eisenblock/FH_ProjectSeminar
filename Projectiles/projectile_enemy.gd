extends CharacterBody2D

var speed = 200
@export var dmg = 10
@export var health = 10
var aggroRange = 500
@export var hitRange = 20
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

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
	#call_deferred("seeker_setup")

func _process(delta: float) -> void:
	if targetPLayer == null:
		return
	if aggroRange >= global_position.distance_to(targetPLayer.global_position):
		gotTriggered = true
	if animated_sprite_2d :
		if direction.x < 0:
			if not animated_sprite_2d.flip_h:  # Nur spiegeln, wenn es noch nicht geschehen ist
				animated_sprite_2d.flip_h = true  # Flippen für nach links
		elif direction.x > 0:
			if animated_sprite_2d.flip_h:  # Nur spiegeln, wenn es nach links gespiegelt ist
				animated_sprite_2d.flip_h = false  # Zurückflippen für nach rechts
		# Animation für "walk" abspielen
		if not animated_sprite_2d.is_playing():  # Falls die Animation noch nicht läuft
			animated_sprite_2d.flip_v = true
			animated_sprite_2d.play("walk_left")
			look_at(targetPLayer.position)

func _physics_process(delta: float) -> void:
	"""if gotTriggered == true :
		nav.target_position = targetPLayer.global_position
		if  !gotHit :
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			velocity = direction * speed
			move_and_slide()
		if gotHit:
			direction = (targetPLayer.global_position - global_position).normalized()
			direction *= -0.3  # Richtung umkehren
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
		"""
	#update_navigation()
	if gotTriggered == true :
		if targetPLayer: 
			nav.target_position = targetPLayer.position
		#if nav.is_navigation_finished() :
		#	return
		
		"""var curren_a_pos = global_position
		var nextpos = nav.get_next_path_position()
		velocity = curren_a_pos.direction_to(nextpos) * speed"""
		if  !gotHit :
			var next_path_position = nav.get_next_path_position()
			direction = (next_path_position - global_position).normalized()
			global_position += direction * 100 * delta
			move_and_slide()
		if gotHit:
			var next_path_position = nav.get_next_path_position()
			direction = (next_path_position - global_position).normalized()
			global_position += direction * -30 * delta
			move_and_slide()
		#move_and_slide()
		#_check_distance()

func update_navigation():
	for region in get_tree().get_nodes_in_group("NavigationRegion2D"):
		if region is NavigationRegion2D:
			var nav_map = region.get_navigation_map()
			if nav_map:
				# Navigationsdaten erzwingen
				NavigationServer2D.map_force_update(nav_map)

func seeker_setup() : 
	await get_tree().physics_frame
	if targetPLayer :
		nav.target_position = targetPLayer.global_position

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
		timerGotHit.connect("timeout", self.resetGotHit)
		timerGotHit.start()
		var player = area.get_parent()
		player.take_damage(dmg)
		gotHit = true

func resetGotHit():
	if timerGotHit :
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
		Global.expAmount += 1
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
