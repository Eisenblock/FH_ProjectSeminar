extends Control
var current_attr = 0
var current_Dic : String = ""
var spawnUI = null
var posInDic = 0
var upgradeCost = [5,10,15]
var addCost = 4
var availableAttributes = {
	
	"tier1": {
		"base_dmg": 2,    
		"pierce"  : 1,  
		"more_projectiles": 1,   
		"attack_speed": 0.2,     
		"lifetime": 0.5,         
			},
	"tier2": {
		"base_dmg": 5,      
		"pierce"  : 2,      
		"more_projectiles": 2,   
		"attack_speed": 0.5,     
		"lifetime": 0.7,         
			},
	"tier3": {
		"base_dmg": 10,    
		"pierce"  : 3,  
		"more_projectiles": 3,   
		"attack_speed": 0.8,     
		"lifetime": 0.9,         
			}
	}
	
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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnUI = get_tree().get_first_node_in_group("spell_uiGlobal")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addAttr():
	if Global.expAmount >= addCost:
		match current_Dic :
			"auto":
				if availableAttributes["tier1"].has(current_attr) and Global.autoShootAttribute.size() < 3:
					Global.autoShootAttribute[current_attr] = availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.autoShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"fireball":
				if availableAttributes["tier1"].has(current_attr)and Global.fireballShootAttribute.size() < 3:
					Global.fireballShootAttribute[current_attr] = availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.fireballShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"darkball":
				if availableAttributes["tier1"].has(current_attr)and Global.darkShootAttribute.size() < 3:
					Global.darkShootAttribute[current_attr] = availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.darkShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"circleball":
				if availableAttributes["tier1"].has(current_attr) and Global.circleShootAttribute.size() < 3:
					Global.circleShootAttribute[current_attr] = availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.circleShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"chest":
				if availableAttributes["tier1"].has(current_attr) and Global.ChestAttribute.size() < 3:
					Global.ChestAttribute[current_attr] = availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.ChestAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)

func ResetAttr(dicRef : Dictionary,dicName : String):
		var old_key
		var keys = dicRef.keys()
		var new_value
		if posInDic < 0 or posInDic >= keys.size():
			print("Fehler: Ungültiger Index", posInDic)
			return

		old_key = keys[posInDic]  # Hole das Attribut basierend auf der Position
		print("________________------",keys[posInDic],posInDic)
		if availableAttributes["tier1"][old_key] == dicRef[old_key]:
			Global.expAmount += addCost 
		if availableAttributes["tier2"][old_key] == dicRef[old_key]:
			Global.expAmount += addCost + upgradeCost[0]
		if availableAttributes["tier3"][old_key] == dicRef[old_key]:
			Global.expAmount += addCost+ upgradeCost[0] + upgradeCost[1]
			"""if availableAttributes_Armor["tier1"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier2"][old_key]
				Global.expAmount -= 5
			if availableAttributes_Armor["tier2"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier3"][old_key]
				Global.expAmount -= 10"""
			# Ersetze das Attribut mit dem neuen Wert
		print("___________________________------------______________________Reset")
		match dicName :
			"auto":
				Global.autoShootAttribute.erase(old_key)
			"fireball":
				Global.fireballShootAttribute.erase(old_key)
			"darkball":
				Global.darkShootAttribute.erase(old_key)
			"circleball":
				Global.circleShootAttribute.erase(old_key)
			"chest":
				Global.ChestAttribute.erase(old_key)
		for key in dicRef.keys():
			print("%s: %s" % [key, str(dicRef[key])])


func UpgradeTierAttr2(dicRef: Dictionary):
	var keys = dicRef.keys()
	if posInDic >= keys.size():
		print("Ungültige Position im Dictionary.")
		return

	var old_key = keys[posInDic]
	var tier = ""
	var cost = 0

	# Bestimme, in welchem Tier das aktuelle Attribut ist
	if availableAttributes["tier1"].has(old_key) and dicRef[old_key] == availableAttributes["tier1"][old_key]:
		tier = "tier2"
		cost = upgradeCost[0]
	elif availableAttributes["tier2"].has(old_key) and dicRef[old_key] == availableAttributes["tier2"][old_key]:
		tier = "tier3"
		cost = upgradeCost[1]
	else:
		print("Upgrade nicht möglich – Attribut ist schon auf maximalem Level oder ungültig.")
		return

	# Überprüfe EXP und führe das Upgrade durch
	if Global.expAmount >= cost:
		var new_value = availableAttributes[tier][old_key]
		dicRef[old_key] = new_value
		Global.expAmount -= cost
		print("Upgrade durchgeführt:", old_key, "->", new_value, "| Rest-EXP:", Global.expAmount)
	else:
		print("Nicht genug EXP für Upgrade. Benötigt:", cost, " | Verfügbar:", Global.expAmount)



func _on_highet_tier_pressedUpgrade() -> void:
	match current_Dic :
		"auto":
			UpgradeTierAttr2(Global.autoShootAttribute)
		"fireball":
			UpgradeTierAttr2(Global.fireballShootAttribute)
		"darkball":
			UpgradeTierAttr2(Global.darkShootAttribute)
		"circleball":
			UpgradeTierAttr2(Global.circleShootAttribute)
		"chest":
			UpgradeTierAttr2(Global.ChestAttribute)#
	spawnUI.DoDetails()

func _on_add_attr_pressedAdd() -> void:
	if current_attr:
		addAttr()
		spawnUI.DoDetails()


func _on_reset_pressedRest() -> void:
	match current_Dic :
		"auto":
			ResetAttr(Global.autoShootAttribute,"auto")
		"fireball":
			ResetAttr(Global.fireballShootAttribute,"fireball")
		"darkball":
			ResetAttr(Global.darkShootAttribute,"darkball")
		"circleball":
			ResetAttr(Global.circleShootAttribute,"circleball")
		"chest":
			ResetAttr(Global.ChestAttribute,"chest")
	spawnUI.DoDetails()
