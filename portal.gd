extends Area2D
@export var MapChange : String 
var portalActive = false

func _on_area_enteredPortal1(area: Area2D) -> void:
	print("not ACtive")
	print("PortalActive Status:", portalActive)
	if portalActive  :
		get_tree().change_scene_to_file(MapChange)
	else :
		print("not ACtive")


func _on_body_entered(body: Node2D) -> void:
	print("not ACtive")
	print("PortalActive Status:", portalActive)
	if portalActive  :
		get_tree().change_scene_to_file(MapChange)
	else :
		print("not ACtive")
