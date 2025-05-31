extends Control

@export var fireball_path: NodePath
@export var dmgButton_bool : bool = false
@export var posInDic = 0

var track_dmg = 0
var track_bonusdmg = 0
var avaibleAttributes := {}

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	# Wähle zufällig ein Attribut aus avaibleAttributes aus
	avaibleAttributes = {
		"base_dmg": 1,          # Grundschaden
		"more_dmg_percent": 0, # Erhöhter Schaden in Prozent (20%)
		"more_projectiles": 0,   # Zusätzliche Projektile
		"attack_speed": 0,     # Angriffsgeschwindigkeit
		"lifetime": 0,         # Lebensdauer des Projektils
		#"can_pierce": true,      # Kann Gegner durchdringen
		"lifesteal": 0       # Lebensraub (5% des Schadens)
	}
	if dmgButton_bool :
		var keys = avaibleAttributes.keys()
		var randNum = randi() % keys.size()
		var selectedAttribute = keys[randNum]
		
		# Hole den Wert für das zufällig ausgewählte Attribut
		var attributeValue = avaibleAttributes[selectedAttribute]
		
		# Füge das Attribut und den Wert zum globalen Dictionary hinzu
		addAttribute(selectedAttribute, attributeValue)
	
	if !dmgButton_bool :
		var keys = avaibleAttributes.keys()
		var randNum = randi() % keys.size()
		var selectedAttribute = keys[randNum]
		
		# Hole den Wert für das zufällig ausgewählte Attribut
		var attributeValue = avaibleAttributes[selectedAttribute]
		
		# Füge das Attribut und den Wert zum globalen Dictionary hinzu
		changeAttribute(selectedAttribute, attributeValue)

func addAttribute(name: String, value: Variant):
	Global.autoShootAttribute[name] = value  # Attribut in das globale Dictionary speichern
	print("Attribut hinzugefügt:", name, "=", value)  # Debug-Ausgabe
	for key in Global.autoShootAttribute.keys():
		print(key, ": ", Global.autoShootAttribute[key])
		

func changeAttribute(name: String  ,value: Variant):
	Global.autoShootAttribute[posInDic] = value  # Attribut in das globale Dictionary speichern
	print("Attribut hinzugefügt:", name, "=", value)  # Debug-Ausgabe
	for key in Global.autoShootAttribute.keys():
		print(key, ": ", Global.autoShootAttribute[key])
