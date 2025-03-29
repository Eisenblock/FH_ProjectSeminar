extends Control

@onready var spawn_spell_ui: Node2D = $"../SpawnSpellUI"


func _process(delta):
	global_position = get_viewport().get_camera_2d().global_position
