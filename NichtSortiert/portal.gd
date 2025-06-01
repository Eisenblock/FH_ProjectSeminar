extends Area2D
@export var MapChange : String 
var portalActive = false
@export var increaseValue = false
@export var bossMap = false

func _on_body_entered(body: Node2D) -> void:
	print("not ACtive")
	if Global.enemyList.size() <= 0 :
		if body.is_in_group("player"):
			var allLifePickUp = get_tree().get_nodes_in_group("Life")
			for child in allLifePickUp :
				child.queue_free()
			print("PortalActive Status:", portalActive)
			if !Global.count_stage % 2 == 0 or Global.count_stage == 0:
				if increaseValue :
					Global.count_stage += 1
				get_tree().change_scene_to_file("res://RoomBiggerEntrance/ProtypeNewMapEntrance.tscn")
			else :
				if bossMap :
					Global.count_stage += 1
					get_tree().change_scene_to_file("res://RoomBiggerEntrance/ProtypeNewMapEntrance.tscn")
				else :
					get_tree().change_scene_to_file("res://boss_room.tscn")
