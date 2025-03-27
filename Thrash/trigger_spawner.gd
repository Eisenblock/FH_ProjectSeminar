extends Area2D


@export var spawner_enemy: Node2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		spawner_enemy.spawnStarted = true
		queue_free()
