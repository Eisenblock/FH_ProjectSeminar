extends Button
@export var reroll_cost: Label 
@export var upgrade_cost_2: Label 
@export var add_cost: Label 
@export var addAttrButton_bool : bool = false
@export var upgradeButton_tier : bool = false
@export var changeAttrButton_bool : bool = false
@export var autoShotButton_bool : bool = false
@export var circleShoot_bool : bool = false
@export var fireballShoot_bool : bool = false
@export var chestButton_bool : bool = false
@export var darkButton_bool : bool = false
@export var switchAttrButton_bool : bool = false
@export var UI_Auto : PackedScene = load("res://UI/controlAuto.tscn")
@export var UI_Auto_Button : PackedScene = load("res://UI/button_dmgAuto.tscn")
@export var UI_Circle : PackedScene = load("res://UI/controlCircle2.tscn")
@export var UI_Circle_Button : PackedScene = load("res://UI/button_dmgCircle.tscn")
@export var UI_Chest : PackedScene = load("res://UI/controlChest.tscn")
@export var UI_Chest_Button : PackedScene = load("res://UI/button_dmgChest.tscn")
@export var UI_Fire : PackedScene = load("res://UI/controlFire.tscn")
@export var UI_Fire_Button : PackedScene = load("res://UI/button_dmgfire.tscn")
@export var UI_Dark : PackedScene = load("res://UI/controlDark.tscn")
@export var UI_Dark_Button : PackedScene = load("res://UI/button_dmgDark.tscn")
@export var countAttrOnChest = 0
@export var posInDic = -2
@onready var spawn_spell_ui: Node2D = $"../SpawnSpellUI"
@onready var label: Label = $"../../../Label"
@onready var current_spekk: Label = $"../CurrentSpekk"
@export var UI_ShowAuto : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowAuto.tscn")
@export var UI_ShowFire : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowFire.tscn")
@export var UI_ShowDark : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_Showdark.tscn")
@export var UI_ShowCircle : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowCircle.tscn")
@export var UI_ShowFire_Empthy : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowFire_empty.tscn")
@export var UI_ShowDark_Empthy : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_Showdark_empty.tscn")
@export var UI_ShowAuto_Empthy : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowAuto_empty.tscn")
@export var UI_ShowCircle_Empthy : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowCircle_empty.tscn")
@onready var h_box_container: VBoxContainer = $"../HBoxContainer"

var changeCost = 4
var upgradeCost = 5
var addCost = 20

var player
var rigthValue : bool = false
var availableAttributes_Armor = {
	"tier1": {
		"Health" : 15,
		"Armor" : 2,
		"Life_Reg" : 0.1
			},
	"tier2": {
		"Health" : 20,
		"Armor" : 4,
		"Life_Reg" : 0.2
			},
	"tier3": {
		"Health" :25,
		"Armor" : 8,
		"Life_Reg" : 0.4
			}
	}


var track_dmg = 0
var track_bonusdmg = 0

func _ready() -> void:
	current_spekk = get_tree().get_first_node_in_group("NameAbility")
	SetAvaibleAttribute()
	var ui_nodes = get_tree().get_nodes_in_group("spell_ui")
	var player_nodes = get_tree().get_nodes_in_group("player")
	if ui_nodes.size() > 0:
		spawn_spell_ui = ui_nodes[0]  # Nimmt das erste gefundene UI-Element
	else:
		print("Fehler: Kein UI-Element in der Gruppe 'spell_ui' gefunden!")
	
	if player_nodes.size() > 0:
		player = player_nodes[0]  # Nimmt das erste gefundene UI-Element
	else:
		print("Fehler: Kein UI-Element in der Gruppe 'spell_ui' gefunden!")

func _process(delta: float) -> void:
	if reroll_cost and upgrade_cost_2 :
		reroll_cost.text = str(changeCost)
		if upgradeCost == 0:
			upgrade_cost_2.text = "Max"
		else :
			upgrade_cost_2.text = str(upgradeCost)


func SetAvaibleAttribute ():
	pass

func addAttribute(name: String, value: Variant, dicRef : Dictionary, countRef  ,sceneRef : PackedScene , sceneButtonRef : PackedScene) -> Array:
	#Add Attr Chest
	if Global.expAmount >= addCost:
		if  countRef <= 3 :
			dicRef[name] = value  # Attribut in das globale Dictionary speichern
			print("Attribut hinzugefügt Auto:", name, "=", value)  # Debug-Ausgabe
			countRef += 1
			spawn_spell_ui.updateTextFieldsRef(dicRef, "chest",countRef,sceneRef,sceneButtonRef)
			var player_nodes = get_tree().get_nodes_in_group("player")
			player = player_nodes[0]
			if dicRef == Global.ChestAttribute :
				player.UpdatePlayerAttr(Global.ChestAttribute)
			for key in dicRef.keys():
				print(key, ": ", dicRef[key])
		else :
			print("Auto Attr Full")
		
		Global.expAmount -= addCost
		self.queue_free()
		return [dicRef, countRef] 
	return [dicRef, countRef] 

func changeAttribute(name: String  ,value: Variant, nameGlobale : String,dicRef : Dictionary, countRef, sceneRef : PackedScene,sceneButtonRef : PackedScene):
	if Global.expAmount >= changeCost :
		Global.expAmount -= changeCost
		var keys = dicRef.keys()
		
		if keys.size() > 0:  # Prüfen, ob Einträge existieren
			var old_key = keys[posInDic]  # Erster Key (kannst auch `posInDic` nutzen)
			var temp_list = []
			for key in keys:
				if key != old_key:
					temp_list.append([key,dicRef[key]])  # Speichert Key + Wert
			dicRef.erase(old_key)
			dicRef.clear()  
			dicRef[name] = value  
			for entry in temp_list:
				dicRef[entry[0]] = entry[1]
			print("Attribut geändert:", old_key, "->", name, "=", value)
			spawn_spell_ui.updateTextFieldsRef(dicRef, "autoShoot",countRef,sceneRef, sceneButtonRef)
			if dicRef == Global.ChestAttribute :
				player.UpdatePlayerAttr(Global.ChestAttribute)
"""func changeAttribute(name: String  ,value: Variant, nameGlobale : String,dicRef : Dictionary, countRef):
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
				"""

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

func UpgradeTierAttr2(Ability_bool : bool, dicRef : Dictionary, countRef  ,sceneRef : PackedScene , sceneButtonRef : PackedScene):
	if Global.expAmount >= upgradeCost :
		var keys = dicRef.keys()
		var new_value
		if posInDic < 0 or posInDic >= keys.size():
			print("Fehler: Ungültiger Index", posInDic)
			return

		var old_key = keys[posInDic]  # Hole das Attribut basierend auf der Position
		if Ability_bool :
			if not Global.availableAttributes["tier2"].has(old_key):
				print("Fehler: Attribut existiert nicht in Tier 2!")
				return
			if Global.availableAttributes["tier1"][old_key] == dicRef[old_key]:
				new_value = Global.availableAttributes["tier2"][old_key]
				Global.expAmount -= 5
			if Global.availableAttributes["tier2"][old_key] == dicRef[old_key]:
				new_value = Global.availableAttributes["tier3"][old_key]
				Global.expAmount -= 10
		else:
			if not availableAttributes_Armor["tier2"].has(old_key):
					print("Fehler: Attribut existiert nicht in Tier 2!")
					return
			if availableAttributes_Armor["tier1"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier2"][old_key]
				Global.expAmount -= 5
			if availableAttributes_Armor["tier2"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier3"][old_key]
				Global.expAmount -= 10

		
		var temp_list = []
		for key in keys:
			if key != old_key:
				temp_list.append([key, dicRef[key]])  # Speichert Key + Wert

		# Ersetze das Attribut mit dem neuen Wert
		dicRef.clear()
		dicRef[old_key] = new_value

		# Füge die anderen Werte wieder hinzu
		for entry in temp_list:
			dicRef[entry[0]] = entry[1]

		print("Attribut", old_key, "wurde auf Tier 2 aktualisiert:", new_value)

		# Falls du die UI updaten möchtest, stelle sicher, dass diese Methode existiert
		if spawn_spell_ui:
			spawn_spell_ui.updateTextFieldsRef(dicRef, "chest",countRef,sceneRef,sceneButtonRef)

func CheckTypeAddAttr():
	var keys = Global.availableAttributes.keys()
	var randNum = randi() % keys.size()
	var selectedAttribute 
	
	if chestButton_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(true,rigthValue,Global.ChestAttribute,keys)
		var attributeValue = availableAttributes_Armor["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		var result = addAttribute(selectedAttribute, attributeValue,Global.ChestAttribute,Global.countAttrOnChest,UI_Chest,UI_Chest_Button)
		Global.ChestAttribute = result[0]
		Global.countAttrOnChest = result[1]
	if autoShotButton_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.autoShootAttribute,keys)
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		var result = addAttribute(selectedAttribute, attributeValue,Global.autoShootAttribute,Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
		Global.autoShootAttribute = result[0]
		Global.countAttrOnAuto = result[1]
	if circleShoot_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.circleShootAttribute,keys)
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		var result = addAttribute(selectedAttribute, attributeValue,Global.circleShootAttribute,Global.countAttrOnCircle,UI_Circle,UI_Circle_Button)
		Global.circleShootAttribute = result[0]
		Global.countAttrOnCircle = result[1]
	if fireballShoot_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.fireballShootAttribute,keys)
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		var result = addAttribute(selectedAttribute, attributeValue,Global.fireballShootAttribute,Global.countAttrOnFire,UI_Fire,UI_Fire_Button)
		Global.fireballShootAttribute = result[0]
		Global.countAttrOnFire = result[1]
	if darkButton_bool and addAttrButton_bool:
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.darkShootAttribute,keys)
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		#var attributeValue = availableAttributes[selectedAttribute]
		var result = addAttribute(selectedAttribute, attributeValue,Global.darkShootAttribute,Global.countAttrOnDark,UI_Dark,UI_Dark_Button)
		Global.darkShootAttribute = result[0]
		Global.countAttrOnDark = result[1]


func CheckTypeChangeAttr():
	var keys = Global.availableAttributes.keys()
	var randNum = randi() % keys.size()
	var selectedAttribute 
	if changeAttrButton_bool:
		if autoShotButton_bool :
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.autoShootAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"autoShoot",Global.autoShootAttribute,Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
		# Füge das Attribut und den Wert zum globalen Dictionary hinzu
		if circleShoot_bool : 
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.circleShootAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"circleShoot",Global.circleShootAttribute,Global.countAttrOnCircle,UI_Circle,UI_Circle_Button)
		if fireballShoot_bool : 
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.fireballShootAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"circleShoot",Global.fireballShootAttribute,Global.countAttrOnFire,UI_Fire,UI_Fire_Button)
		if darkButton_bool : 
			selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.darkShootAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"circleShoot",Global.darkShootAttribute,Global.countAttrOnDark,UI_Dark,UI_Dark_Button)
		if chestButton_bool : 
			keys = availableAttributes_Armor.keys()
			selectedAttribute = CheckAttr_isValid(true,rigthValue,Global.ChestAttribute,keys)
			#var attributeValue = availableAttributes["tier1"][selectedAttribute]
			var attributeValue = availableAttributes_Armor["tier1"][selectedAttribute]
			changeAttribute(selectedAttribute, attributeValue,"circleShoot",Global.ChestAttribute,Global.countAttrOnChest,UI_Chest,UI_Chest_Button)

func CheckUPgradeTier():
	var keys = Global.availableAttributes.keys()
	var randNum = randi() % keys.size()
	var selectedAttribute 
	if autoShotButton_bool :
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.autoShootAttribute,keys)
		#var attributeValue = availableAttributes["tier1"][selectedAttribute]
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		UpgradeTierAttr2(true,Global.autoShootAttribute,Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
	# Füge das Attribut und den Wert zum globalen Dictionary hinzu
	if circleShoot_bool : 
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.circleShootAttribute,keys)
		#var attributeValue = availableAttributes["tier1"][selectedAttribute]
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		UpgradeTierAttr2(true,Global.circleShootAttribute,Global.countAttrOnCircle,UI_Circle,UI_Circle_Button)
	if fireballShoot_bool : 
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.fireballShootAttribute,keys)
		#var attributeValue = availableAttributes["tier1"][selectedAttribute]
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		UpgradeTierAttr2(true,Global.fireballShootAttribute,Global.countAttrOnFire,UI_Fire,UI_Fire_Button)
	if darkButton_bool : 
		selectedAttribute = CheckAttr_isValid(false,rigthValue,Global.darkShootAttribute,keys)
		#var attributeValue = availableAttributes["tier1"][selectedAttribute]
		var attributeValue = Global.availableAttributes["tier1"][selectedAttribute]
		UpgradeTierAttr2(true,Global.darkShootAttribute,Global.countAttrOnDark,UI_Dark,UI_Dark_Button)
	if chestButton_bool : 
		var newkeys = availableAttributes_Armor.keys()
		selectedAttribute = CheckAttr_isValid(true,rigthValue,Global.ChestAttribute,newkeys)
		#var attributeValue = availableAttributes["tier1"][selectedAttribute]
		var attributeValue = availableAttributes_Armor["tier1"][selectedAttribute]
		UpgradeTierAttr2(false,Global.ChestAttribute,Global.countAttrOnChest,UI_Chest,UI_Chest_Button)

func SwitchAttrShow():
	#Switch AttrShow
	if autoShotButton_bool:
		#spawn_spell_ui.updateTextFieldsRef(Global.autoShootAttribute,"",Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
		spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"auto")
		current_spekk.text = "Auto"
	if circleShoot_bool : 
		#spawn_spell_ui.updateTextFieldsRef(Global.circleShootAttribute,"",Global.countAttrOnCircle,UI_Circle,UI_Circle_Button)
		spawn_spell_ui.SwitchAttribute(Global.circleShootAttribute,"circleball")
		current_spekk.text = "Circle"
	if fireballShoot_bool : 
		#spawn_spell_ui.updateTextFieldsRef(Global.fireballShootAttribute,"",Global.countAttrOnFire,UI_Fire,UI_Fire_Button)
		spawn_spell_ui.SwitchAttribute(Global.fireballShootAttribute,"fireball")
		current_spekk.text = "Fire"
	if darkButton_bool : 
		#spawn_spell_ui.updateTextFieldsRef(Global.darkShootAttribute,"",Global.countAttrOnDark,UI_Dark,UI_Dark_Button)
		spawn_spell_ui.SwitchAttribute(Global.darkShootAttribute,"darkball")
		current_spekk.text = "Dark"
	if chestButton_bool : 
		#spawn_spell_ui.updateTextFieldsRef(Global.ChestAttribute,"",Global.countAttrOnChest,UI_Chest,UI_Chest_Button)
		spawn_spell_ui.SwitchAttribute(Global.ChestAttribute,"chest")
		current_spekk.text = "Chest"
func _on_pressed() -> void:
	#print("bUTTON geeeeeeeeeeeht")
	# Wähle zufällig ein Attribut aus avaibleAttributes aus
	rigthValue  = false
	#var keys = availableAttributes["tier1"].keys()
	var keys = Global.availableAttributes.keys()
	var randNum = randi() % keys.size()
	var selectedAttribute 
	#Switch Attr
	if switchAttrButton_bool :
		SwitchAttrShow()
	#Add Attr 
	if addAttrButton_bool :
		CheckTypeAddAttr()
	
	#Change Attr
	if changeAttrButton_bool :
		CheckTypeChangeAttr()
	
		
	if upgradeButton_tier : 
		CheckUPgradeTier()
	

func CheckAttr_isValid(refType_bool: bool, ref_RightValue_bool: bool, ref_Dic: Dictionary, ref_keys) -> String:
	var selectedAttribute
	if ref_keys.size() >= 0 :
		var ref_keys_tier1 = ref_Dic.keys()  # Hole alle Attribute aus "tier1"
	
	while not ref_RightValue_bool: 
		if refType_bool == false :
			var randNum = randi() % Global.availableAttributes["tier1"].keys().size()
			selectedAttribute = Global.availableAttributes["tier1"].keys()[randNum]
			#print(selectedAttribute)# Wähle ein zufälliges Attribut
		else :
			var randNum = randi() % availableAttributes_Armor["tier1"].keys().size()
			selectedAttribute = availableAttributes_Armor["tier1"].keys()[randNum]
			#print(selectedAttribute)# Wähle ein zufälliges Attribut
		# Überprüfe, ob das Attribut noch nicht im Dictionary ist
		if not ref_Dic.has(selectedAttribute):
			ref_RightValue_bool = true  # Gültiges Attribut gefunden
			
	return selectedAttribute


func _on_pressedAuto() -> void:
	if Global.expAmount >= addCost :
		Global.expAmount -= addCost
		spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"auto")
		current_spekk.text = "Auto"
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player2 = player_nodes[0]

			Global.learned_abilities["auto"] = true
			player2.autoBall = true  # <- nur wenn player gültig
			player2.load_abilities()

			var instance = UI_ShowAuto.instantiate()
			instance.position = self.position
			var box = get_tree().get_first_node_in_group("Ability_box")
			box.add_child(instance)
			self.queue_free()
		else:
			print("Kein Player gefunden!")


func _on_pressedCircle() -> void:
	if Global.expAmount >= addCost :
		Global.expAmount -= addCost
		spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"circleball")
		current_spekk.text = "Circle"
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player2 = player_nodes[0]

			Global.learned_abilities["circleball"] = true
			player2.circleBall = true  # <- nur wenn player gültig

			var instance = UI_ShowCircle.instantiate()
			instance.position = self.position
			var box = get_tree().get_first_node_in_group("Ability_box")
			box.add_child(instance)
			self.queue_free()
		else:
			print("Kein Player gefunden!")


func _on_pressedDark() -> void:
	if Global.expAmount >= addCost :
		Global.expAmount -= addCost
		spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"darkball")
		current_spekk.text = "Darkball"
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player2 = player_nodes[0]

			Global.learned_abilities["darkball"] = true
			player2.darkBall = true  # <- nur wenn player gültig
			player2.load_abilities()

			var instance = UI_ShowDark.instantiate()
			instance.position = self.position
			var box = get_tree().get_first_node_in_group("Ability_box")
			box.add_child(instance)
			self.queue_free()
		else:
			print("Kein Player gefunden!")

func _on_pressedFire() -> void:
	if Global.expAmount >= addCost :
		Global.expAmount -= addCost
		spawn_spell_ui.SwitchAttribute(Global.autoShootAttribute,"fireball")
		current_spekk.text = "Fireball"
		var player_nodes = get_tree().get_nodes_in_group("player")
		if player_nodes.size() > 0:
			var player2 = player_nodes[0]

			Global.learned_abilities["fireball"] = true
			player2.fireBall = true  # <- nur wenn player gültig
			player2.load_abilities()
			var instance = UI_ShowFire.instantiate()
			instance.position = self.position
			var box = get_tree().get_first_node_in_group("Ability_box")
			box.add_child(instance)
			self.queue_free()
		else:
			print("Kein Player gefunden!")




func _on_reste_ability_pressedResetAbilityFire() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player2 = player_nodes[0]
		player2.fireBall = false 
	if Global.learned_abilities.has("fireball"):
		Global.learned_abilities.erase("fireball")
		spawn_spell_ui.ClearDetails()
		current_spekk.text = "None"
		var instance = UI_ShowFire_Empthy.instantiate()
		instance.position = self.position
		var box = get_tree().get_first_node_in_group("Ability_box")
		box.add_child(instance)
		self.queue_free()
	else:
		print("Kein Player gefunden!")
	Global.expAmount += addCost


func _on_reste_ability_pressedResetAbilityDark() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player2 = player_nodes[0]
		player2.darkBall = false 
	if Global.learned_abilities.has("darkball"):
		Global.learned_abilities.erase("darkball")
		spawn_spell_ui.ClearDetails()
		current_spekk.text = "None"
		var instance = UI_ShowDark_Empthy.instantiate()
		instance.position = self.position
		var box = get_tree().get_first_node_in_group("Ability_box")
		box.add_child(instance)
		self.queue_free()
	else:
		print("Kein Player gefunden!")
	Global.expAmount += addCost


func _on_reste_ability_pressedResetAbilityCircle() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player2 = player_nodes[0]
		player2.circleBall = false 
	if Global.learned_abilities.has("circleball"):
		Global.learned_abilities.erase("circleball")
		spawn_spell_ui.ClearDetails()
		current_spekk.text = "None"
		var instance = UI_ShowCircle_Empthy.instantiate()
		instance.position = self.position
		var box = get_tree().get_first_node_in_group("Ability_box")
		box.add_child(instance)
		self.queue_free()
	else:
		print("Kein Player gefunden!")
	Global.expAmount += addCost


func _on_reste_ability_pressedResetAbilityAuto() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player2 = player_nodes[0]
		player2.autoBall = false 
	if Global.learned_abilities.has("auto"):
		Global.learned_abilities.erase("auto")
		spawn_spell_ui.ClearDetails()
		current_spekk.text = "None"
		var instance = UI_ShowAuto_Empthy.instantiate()
		instance.position = self.position
		var box = get_tree().get_first_node_in_group("Ability_box")
		box.add_child(instance)
		self.queue_free()
	else:
		print("Kein Player gefunden!")
	Global.expAmount += addCost
