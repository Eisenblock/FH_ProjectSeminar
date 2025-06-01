extends Node2D


@export var fireball_boolPIckUP : bool = false
@export var circleball_boolPickUp : bool = false
@export var darkball_boolPickUp : bool = false
var killTimer : Timer

func _ready() -> void:
	pass
	"""killTimer = Timer.new()
	killTimer.wait_time = 8
	killTimer.one_shot = true
	killTimer.timeout.connect(Callable(self, "KillObject"))
	add_child(killTimer)
	killTimer.start()"""


func GetPLayer():
	var nodes_in_group = get_tree().get_nodes_in_group("player")

func KillObject():
	queue_free()

func save_ability(name: String, is_active: bool):
	Global.learned_abilities[name] = is_active  # Speichern, ob aktiv oder nicht
	print("Gespeicherte Fähigkeit:", name, "=", is_active)


func _on_pick_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if fireball_boolPIckUP :
			body.fireBall = true
			save_ability("fireball",true)
		if circleball_boolPickUp:
			print("PIckUp")
			body.circleBall = true
			save_ability("circleball",true)
		if darkball_boolPickUp :
			body.darkBall = true
			save_ability("darkball",true)
		queue_free()

func SetPickUPValue(nameRef :String):
	if name == "fireball" :
		fireball_boolPIckUP = true
		print("fireball")
	if name == "darkball" :
		darkball_boolPickUp = true
		print("darkball")
	if name == "circleball" :
		circleball_boolPickUp = true
		print("circleball")


func _on_pick_up_area_enteredHealth(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.life_player += 5
		if Global.life_player > 20 :
			Global.life_player = 20
		queue_free()
