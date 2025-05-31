extends Area2D
var allMove_tilemaps = null
var allBlock_tilemaps = null
var boss = null
var finish = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	allMove_tilemaps = get_tree().get_nodes_in_group("TileMap_Move")
	allBlock_tilemaps = get_tree().get_nodes_in_group("BlockedField")
	boss = get_tree().get_first_node_in_group("Boss")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_enteredStartGame(body: Node2D) -> void:
	if body.is_in_group("player") and !finish:
		for object in allMove_tilemaps :
			object.StartMovement()
		for object in allBlock_tilemaps :
			object.set_layer_enabled(0, true)
		if boss :
			boss.StartBossFight()
		finish = true
