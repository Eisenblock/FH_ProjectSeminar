extends Node2D

var killTimer : Timer
var explode : PackedScene = load("res://Projectiles/explodeProjectile_enemy.tscn") # Passe den Pfad an!

func _ready() -> void:
	killTimer = Timer.new()
	killTimer.wait_time = 2
	killTimer.one_shot = true
	killTimer.connect("timeout", Callable(self, "_on_KillTimer_timeout"))
	add_child(killTimer)
	killTimer.start()

func _on_KillTimer_timeout() -> void:
	# Explosion instanzieren
	if explode:
		var explosion_instance = explode.instantiate()
		explosion_instance.global_position = global_position
		explosion_instance.dmg = 2
		get_parent().add_child(explosion_instance)

	# Dieses Objekt entfernen
	queue_free()
