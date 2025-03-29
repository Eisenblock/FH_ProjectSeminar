extends Button

@onready var spawn_spell_ui: Node2D = $"../SpawnSpellUI"


func _on_pressed() -> void:
	spawn_spell_ui.SwitchAttribute(Global.ChestAttribute,"chest",Global.countAttrOnChest)
