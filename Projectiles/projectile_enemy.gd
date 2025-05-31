extends CharacterBody2D

@export var MeeleEnemy : bool = false
@export var  RangeEnemy : bool = false
@export var ShotScene : PackedScene
@export var DmgText : PackedScene 
var pickUpLIfe : PackedScene = load("res://NichtSortiert/Pick_UP.tscn")
var CDShot : bool = false
var timerShot : float = 2
@export var speed = 200
var tempSpeed = 2
var nameAnim : String = "walk_left"
@export var dmg = 10
@export var health = 10
var aggroRange = 500
@export var hitRange = 20
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const MIN_DISTANCE = 20  # Mindestabstand zwischen Gegnern
const PUSH_FORCE = 0.5   # Wie stark sie sich wegschieben
var timerGotHit : Timer
var timerResetTakeDamage : Timer
var gotTriggered : bool = false
var targetPLayer : CharacterBody2D
var accel = 7
var direction = Vector3()
var gotCrit = false
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
		animated_sprite_2d.flip_h = targetPLayer.global_position.x < global_position.x
	"""if animated_sprite_2d :
		if direction.x > 0:
			if  animated_sprite_2d.flip_h:  # Nur spiegeln, wenn es noch nicht geschehen ist
				animated_sprite_2d.flip_h = false  # Flippen für nach links
		elif direction.x < 0:
			if not animated_sprite_2d.flip_h:  # Nur spiegeln, wenn es nach links gespiegelt ist
				animated_sprite_2d.flip_h = true  # Zurückflippen für nach rechts
		# Animation für "walk" abspielen
		if not animated_sprite_2d.is_playing():  # Falls die Animation noch nicht läuft
			animated_sprite_2d.flip_v = true
			if tempSpeed <= 0 :
				nameAnim = "idle"
			animated_sprite_2d.play(nameAnim)
			#look_at(targetPLayer.position)"""
	if gotTriggered and RangeEnemy and !CDShot:
		DoRangeAttack()
		nameAnim = "shoot"
		timerShot = 2
		await get_tree().create_timer(0.5).timeout
		nameAnim = "walk_left"
	if CDShot :
		timerShot -= delta
		if timerShot <= 0 :
			CDShot = false

func _physics_process(delta: float) -> void:

	if gotTriggered == true :
		if targetPLayer: 
			nav.target_position = targetPLayer.position
		var next_path_position = nav.get_next_path_position()
		var distance_to_next = global_position.distance_to(targetPLayer.global_position)
		if !gotHit and RangeEnemy :
			if distance_to_next > 200:
				direction = (next_path_position - global_position).normalized()
				tempSpeed = speed
				global_position += direction * tempSpeed * delta
				nameAnim = "walk_left"
				move_and_slide()
			else:
				tempSpeed = 0
				nameAnim = "idle"
				move_and_slide()
		
		
		if  !gotHit  and MeeleEnemy:
			next_path_position = nav.get_next_path_position()
			direction = (next_path_position - global_position).normalized()
			global_position += direction * speed * delta
			move_and_slide()
		if gotHit and MeeleEnemy:
			next_path_position = nav.get_next_path_position()
			direction = (next_path_position - global_position).normalized()
			global_position += direction * -(speed/6) * delta
			move_and_slide()
		_check_distance()

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
	if area.is_in_group("player") and MeeleEnemy :
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
	if !isDead :
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
		var dmgText = DmgText.instantiate()
		if gotCrit :
			dmgText.modulate = Color("ffff3b")
			gotCrit = false
		get_tree().root.add_child(dmgText)
		dmgText.dmg_value = amount
		dmgText.position = self.global_position #Vector2(5,-40)
		if health <= 0 and !isDead :
			isDead = true
			Global.enemyList.erase(self)
			Global.expAmount += 1
			Dead()

func Dead():
	speed = 0
	var randNumHealth = randi_range(0,20)
	if randNumHealth < 1 :
		var instance = pickUpLIfe.instantiate()
		instance.global_position = self.global_position
		get_tree().root.add_child(instance)
	if animated_sprite_2d :
		animated_sprite_2d.play("dead")
		await  get_tree().create_timer(0.5).timeout
		Global.enemy_kills += 1
		queue_free()
	else :
		queue_free()

func _check_distance():
	for enemy in Global.enemyList:
		if enemy != self and enemy != null and !enemy.isDead and !self.isDead:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < MIN_DISTANCE:
				var direction = (global_position - enemy.global_position).normalized()
				global_position += direction * PUSH_FORCE

# Funktion, um die Position des Gegners anzupassen
func _adjust_position(distance, other_enemy):
	
	var direction = (global_position - other_enemy.global_position).normalized()
	
	
	global_position = other_enemy.global_position + direction * 10


func ResetModular():
	self.modulate = Color("ffffff")

func DoRangeAttack():
	var instance = ShotScene.instantiate()
	if instance != null :
		instance.position = global_position
		var dirForShot = (targetPLayer.position - global_position).normalized()
		instance.SetDir(dirForShot)
		instance.SetDmg(dmg)
		CDShot = true
		get_tree().root.add_child(instance)

func GotCritTrue():
	gotCrit = true
