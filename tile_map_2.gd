extends TileMap

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	#set_layer_enabled(0, true)  # Layer 0 aktivieren
