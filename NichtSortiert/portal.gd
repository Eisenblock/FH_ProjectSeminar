extends Area2D
@export var MapChange : String 
var portalActive = false

func _on_area_enteredPortal1(area: Area2D) -> void:
	print("not ACtive")
	if Global.enemyList.size() <= 0 :
		if area.is_in_group("player"):
			print("PortalActive Status:", portalActive)
			if portalActive  :
				get_tree().change_scene_to_file(MapChange)
			else :
				print("not ACtive")


func _on_body_entered(body: Node2D) -> void:
	print("not ACtive")
	print("PortalActive Status:", portalActive)
	if Global.enemyList.size() <= 0 :
		if body.is_in_group("player"):
			if !Global.count_stage % 2 == 0:
				if portalActive  :
					get_tree().change_scene_to_file(MapChange)
				else :
					print("not ACtive")
			else :
				if portalActive  :
					get_tree().change_scene_to_file("res://boss_room.tscn")
				else :
					print("not ACtive")
