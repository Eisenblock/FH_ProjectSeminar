extends Button
""""Fireball" : 1,
	"Circleball" : 1,"""
@export var dmgButton_bool : bool = false
@export var addAttrButton_bool : bool = false
@export var upgradeButton_tier : bool = false
@export var changeAttrButton_bool : bool = false
@export var autoShotButton_bool : bool = false
@export var circleShoot_bool : bool = false
@export var chestButton_bool : bool = false
@export var countAttrOnChest = 0
@export var posInDic = -2
@onready var spawn_spell_ui: Node2D = $"../SpawnSpellUI"
@onready var label: Label = $"../../../Label"

var player
var rigthValue : bool = false
var availableAttributes_Armor = {
	"tier1": {
		"Health" : randi_range(5,20),
		"Armor" : randi_range(2,10),
		"Life_Reg" : randi_range(1,4)
			}
	}
var availableAttributes = {
	
	"tier1": {
		"base_dmg": randi_range(5, 15),          
		"more_dmg_percent": randi_range(5, 25), 
		"more_projectiles": 1,   
		"attack_speed": randf_range(0.3, 0.7),     
		"lifetime": randi_range(1, 2),         
		"lifesteal": randf_range(0.1, 0.5)  
			},
	"tier2": {
		"base_dmg": randi_range(15, 25),          
		"more_dmg_percent": randi_range(25, 50), 
		"more_projectiles": 2,   
		"attack_speed": randf_range(0.1, 0.3),     
		"lifetime": randi_range(3, 4),         
		"lifesteal": randf_range(0.5, 1)  
			}
	}

var track_dmg = 0
var track_bonusdmg = 0

func _ready() -> void:
	SetAvaibleAttribute()
	var ui_nodes = get_tree().get_nodes_in_group("spell_ui")
	var player_nodes = get_tree().get_nodes_in_group("player")
	if ui_nodes.size() > 0:
		spawn_spell_ui = ui_nodes[0]  # Nimmt das erste gefundene UI-Element
	else:
		print("Fehler: Kein UI-Element in der Gruppe 'spell_ui' gefunden!")
	if player_nodes.size() > 0:
		player = ui_nodes[0]  # Nimmt das erste gefundene UI-Element
	else:
		print("Fehler: Kein UI-Element in der Gruppe 'spell_ui' gefunden!")

func SetAvaibleAttribute ():
	pass

func addAttribute(name: String, value: Variant):
	#Add Attr Chest
	if Global.expAmount >= 2 :
		if chestButton_bool and Global.countAttrOnChest < 5 :
			Global.ChestAttribute[name] = value  # Attribut in das globale Dictionary speichern
			print("Attribut hinzugefügt Auto:", name, "=", value)  # Debug-Ausgabe
			Global.countAttrOnChest += 1
			spawn_spell_ui.updateTextFieldsRef(Global.ChestAttribute, "chest",Global.countAttrOnAuto)
			player.UpdatePlayerAttr(Global.ChestAttribute)
			for key in Global.ChestAttribute.keys():
				print(key, ": ", Global.ChestAttribute[key])
		else :
			print("Auto Attr Full")
		
		#Add Attr Auto
		if autoShotButton_bool and Global.countAttrOnAuto < 5 :
			Global.autoShootAttribute[name] = value  # Attribut in das globale Dictionary speichern
			print("Attribut hinzugefügt Auto:", name, "=", value)  # Debug-Ausgabe
			Global.countAttrOnAuto += 1
			spawn_spell_ui.updateTextFieldsRef(Global.autoShootAttribute, "autoShoot",Global.countAttrOnAuto)
			for key in Global.ChestAttribute.keys():
				print(key, ": ", Global.ChestAttribute[key])
		else :
			print("Auto Attr Full")
			
			
		
		#Add Attr Circle
		if circleShoot_bool and Global.countAttrOnCircle < 5 :
			Global.circleShootAttribute[name] = value  # Attribut in das globale Dictionary speichern
			print("Attribut hinzugefügt Circle:", name, "=", value)  # Debug-Ausgabe
			Global.countAttrOnCircle += 1
			spawn_spell_ui.updateTextFieldsRef(Global.circleShootAttribute,"circleShoot",Global.countAttrOnCircle)
			for key in Global.circleShootAttribute.keys():
				print(key, ": ", Global.circleShootAttribute[key])
		else :
			print("Circle Attr Full")
			
		Global.expAmount -= 2
		self.queue_free()


func changeAttribute(name: String  ,value: Variant, nameGlobale : String):
	if Global.expAmount >= 2 :
		if nameGlobale == "auto_shoot" :
			var keys = Global.ChestAttribute.keys()
			
			if keys.size() > 0:  # Prüfen, ob Einträge existieren
				var old_key = keys[posInDic]  # Erster Key (kannst auch `posInDic` nutzen)
				var temp_list = []
				for key in keys:
					if key != old_key:
						temp_list.append([key, Global.ChestAttribute[key]])  # Speichert Key + Wert
				Global.ChestAttribute.erase(old_key)
				Global.ChestAttribute.clear()  
				Global.ChestAttribute[name] = value  
				for entry in temp_list:
					Global.ChestAttribute[entry[0]] = entry[1]
				print("Attribut geändert:", old_key, "->", name, "=", value)
				spawn_spell_ui.updateTextFieldsRef(Global.ChestAttribute, "autoShoot",Global.countAttrOnAuto)
		
		if nameGlobale == "circle_shoot" :
			var keys = Global.circleShootAttribute.keys()
			
			if keys.size() > 0:  # Prüfen, ob Einträge existieren
				var old_key = keys[posInDic]  # Erster Key (kannst auch `posInDic` nutzen)
				var temp_list = []
				for key in keys:
					if key != old_key:
						temp_list.append([key, Global.circleShootAttribute[key]])  # Speichert Key + Wert
				Global.circleShootAttribute.erase(old_key)
				Global.circleShootAttribute.clear()  
				Global.circleShootAttribute[name] = value  
				for entry in temp_list:
					Global.circleShootAttribute[entry[0]] = entry[1]
				print("Attribut geändert:", old_key, "->", name, "=", value)
				spawn_spell_ui.updateTextFieldsRef(Global.circleShootAttribute, "circleShoot",Global.countAttrOnCircle)

func UpgradeTierAttr(name: String  ,value: Variant, nameGlobale : String):
	if nameGlobale == "auto_shoot" :
		var keys = Global.autoShootAttribute.keys()
		
		if keys.size() > 0:  # Prüfen, ob Einträge existieren
			var old_key = keys[posInDic]  # Erster Key (kannst auch `posInDic` nutzen)
			var temp_list = []
			for key in keys:
				if key != old_key:
					temp_list.append([key, Global.autoShootAttribute[key]])  # Speichert Key + Wert
					Global.autoShootAttribute.erase(old_key)
					Global.autoShootAttribute.clear()  
					#selectedAttribute = Global.autoShootAttribute[name]
					Global.autoShootAttribute["tier2"][name] = value  
					for entry in temp_list:
						Global.autoShootAttribute[entry[0]] = entry[1]
						print("Attribut geändert:", old_key, "->", name, "=", value)
						spawn_spell_ui.updateTextFieldsRef(Global.autoShootAttribute, "autoShoot",Global.countAttrOnAuto)

func UpgradeTierAttr2( attribute_dict: Dictionary):
	var keys = attribute_dict.keys()
	
	if posInDic < 0 or posInDic >= keys.size():
		print("Fehler: Ungültiger Index", posInDic)
		return

	var old_key = keys[posInDic]  # Hole das Attribut basierend auf der Position

	if not availableAttributes["tier2"].has(old_key):
		print("Fehler: Attribut existiert nicht in Tier 2!")
		return

	# Wert aus Tier 2 holen
	var new_value = availableAttributes["tier2"][old_key]

	# Speichere alle alten Werte außer dem zu ersetzenden Attribut
	var temp_list = []
	for key in keys:
		if key != old_key:
			temp_list.append([key, attribute_dict[key]])  # Speichert Key + Wert

	# Ersetze das Attribut mit dem neuen Wert
	attribute_dict.clear()
	attribute_dict[old_key] = new_value

	# Füge die anderen Werte wieder hinzu
	for entry in temp_list:
		attribute_dict[entry[0]] = entry[1]

	print("Attribut", old_key, "wurde auf Tier 2 aktualisiert:", new_value)

	# Falls du die UI updaten möchtest, stelle sicher, dass diese Methode existiert
	if spawn_spell_ui:
		spawn_spell_ui.updateTextFieldsRef(attribute_dict, "autoShoot", Global.countAttrOnAuto)




func _on_pressed() -> void:
	# Wähle zufällig ein Attribut aus avaibleAttributes aus
	rigthValue  = false
	#var keys = availableAttributes["tier1"].keys()
	var keys = availableAttributes.keys()
	var randNum = randi() % keys.size()
	var selectedAttribute 
	
	if chestButton_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(true,rigthValue,Global.ChestAttribute,keys)
		var attributeValue = availableAttributes_Armor["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		addAttribute(selectedAttribute, attributeValue)
	
	if autoShotButton_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.autoShootAttribute,keys)
		var attributeValue = availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		addAttribute(selectedAttribute, attributeValue)
	
	if circleShoot_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.circleShootAttribute,keys)
		var attributeValue = availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		addAttribute(selectedAttribute, attributeValue)
		
	if changeAttrButton_bool:
		if autoShotButton_bool :
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.ChestAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = availableAttributes[selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"autoShoot")
		# Füge das Attribut und den Wert zum globalen Dictionary hinzu
		
		if circleShoot_bool : 
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.circleShootAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = availableAttributes[selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"circleShoot")
		
	if upgradeButton_tier : 
		if autoShotButton_bool :
			UpgradeTierAttr2(Global.ChestAttribute)
		if circleShoot_bool :
			UpgradeTierAttr2(Global.circleShootAttribute)

"""func CheckAttr_isValid(refType_bool : bool,ref_RightValue_bool : bool,ref_Dic : Dictionary, ref_keys) -> String:
	var selectedAttribute 
	while ref_RightValue_bool == false: 
		var randNum = randi() % ref_keys.size()
		selectedAttribute = ref_keys[randNum]
		if autoShotButton_bool :
			if not ref_Dic.has(selectedAttribute):
				ref_RightValue_bool = true
		if circleShoot_bool :
			if not ref_Dic.has(selectedAttribute):
				ref_RightValue_bool = true
	rigthValue = false
	return selectedAttribute"""
func CheckAttr_isValid(refType_bool: bool, ref_RightValue_bool: bool, ref_Dic: Dictionary, ref_keys) -> String:
	var selectedAttribute
	if ref_keys.size() >= 0 :
		var ref_keys_tier1 = ref_Dic.keys()  # Hole alle Attribute aus "tier1"
	
	while not ref_RightValue_bool: 
		if refType_bool == false :
			var randNum = randi() % availableAttributes["tier1"].keys().size()
			selectedAttribute = availableAttributes["tier1"].keys()[randNum]
			print(selectedAttribute)# Wähle ein zufälliges Attribut
		else :
			var randNum = randi() % availableAttributes_Armor["tier1"].keys().size()
			selectedAttribute = availableAttributes_Armor["tier1"].keys()[randNum]
			print(selectedAttribute)# Wähle ein zufälliges Attribut
		# Überprüfe, ob das Attribut noch nicht im Dictionary ist
		if not ref_Dic.has(selectedAttribute):
			ref_RightValue_bool = true  # Gültiges Attribut gefunden
			
	return selectedAttribute
