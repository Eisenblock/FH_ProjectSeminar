extends Area2D
@export var MapChange : String 

func _on_area_enteredPortal1(area: Area2D) -> void:
	print("wwwwwwwwwwww")
	get_tree().change_scene_to_file(MapChange)
