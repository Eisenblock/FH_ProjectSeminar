extends Control
#@onready var spawn_spell_ui: Node2D = $"../SpawnSpellUI"
var spawn_spell_ui

func _ready() -> void:
	GetUISPawner()

func _process(delta):
	pass


func _on_chest_pressedChest() -> void:
	spawn_spell_ui.SwitchAttribute(Global.ChestAttribute,"chest",Global.countAttrOnChest)


func _on_auto_pressedAuto() -> void:
	spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"autoShoot",Global.countAttrOnAuto)

func _on_circle_pressedCircle() -> void:
	spawn_spell_ui.SwitchAttribute(Global.circleShootAttribute,"circleShoot",Global.countAttrOnCircle)

func GetUISPawner():
	var nodes_in_group = get_tree().get_nodes_in_group("spell_ui")
	spawn_spell_ui = nodes_in_group[0]
