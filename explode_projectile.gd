extends Node2D
@export var dmg : float = 10
var timerLifetime : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Timer erstellen und konfigurieren
	timerLifetime = Timer.new()
	timerLifetime.wait_time = 1.0  # Nach 1 Sekunde
	timerLifetime.one_shot = true  # Nur einmal ausführen
	
	add_child(timerLifetime)  # Timer als Kind-Node hinzufügen
	timerLifetime.timeout.connect(_on_timer_timeout)  # Signal verbinden
	timerLifetime.start()  # Timer starten

func _on_timer_timeout() -> void:
	queue_free()  # Objekt löschen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var current_enemy = area.get_parent()
		if current_enemy != null :
			current_enemy.take_damage(dmg)
