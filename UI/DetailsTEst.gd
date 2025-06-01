extends Control
var current_attr = 0
var current_Dic : String = ""
var spawnUI = null
var posInDic = 0
var upgradeCost = [5,10,15,20,25]
var upgradeCost_higher = [10,20,30]
var addCost = 4
@onready var add_attr: Button = $AddAttr
@onready var label: Label = $Label

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
	if label :
		label.text = " c:" + str(addCost)

func addAttrNormal():
	if Global.expAmount >= addCost:
		match current_Dic :
			"auto":
				if Global.availableAttributes["tier1"].has(current_attr) and Global.autoShootAttribute.size() < 3:
					Global.autoShootAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.autoShootAttribute[current_attr])
					Global.expAmount -= addCost
					for key in Global.autoShootAttribute.keys():
						print("_____%s: %s" % [key, str(Global.autoShootAttribute[key])])
				else:
					print("Attribut nicht gefunden:", current_attr)
			"fireball":
				if Global.availableAttributes["tier1"].has(current_attr)and Global.fireballShootAttribute.size() < 3:
					Global.fireballShootAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.fireballShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"darkball":
				if Global.availableAttributes["tier1"].has(current_attr)and Global.darkShootAttribute.size() < 3:
					Global.darkShootAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.darkShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"circleball":
				if Global.availableAttributes["tier1"].has(current_attr) and Global.circleShootAttribute.size() < 3:
					Global.circleShootAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.circleShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"chest":
				if Global.availableAttributes["tier1"].has(current_attr) and Global.ChestAttribute.size() < 3:
					Global.ChestAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
					print("Attribut hinzugefügt:", current_attr, "=", Global.ChestAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)

func addAttrHigher():
	if Global.expAmount >= addCost:
		match current_Dic :
			"auto":
				if Global.availableAttributes_higher["tier1"].has(current_attr) and Global.autoShootAttribute.size() < 3:
					Global.autoShootAttribute[current_attr] = Global.availableAttributes_higher["tier1"][current_attr]
					#rint("Attribut hinzugefügt:", current_attr, "=", Global.availableAttributes_higher[current_attr])
					Global.expAmount -= addCost
					for key in Global.autoShootAttribute.keys():
						print("_____%s: %s" % [key, str(Global.autoShootAttribute[key])])
				else:
					print("Attribut nicht gefunden:", current_attr)
			"fireball":
				if Global.availableAttributes_higher["tier1"].has(current_attr)and Global.fireballShootAttribute.size() < 3:
					Global.fireballShootAttribute[current_attr] = Global.availableAttributes_higher["tier1"][current_attr]
					#print("Attribut hinzugefügt:", current_attr, "=", Global.fireballShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"darkball":
				if Global.availableAttributes_higher["tier1"].has(current_attr)and Global.darkShootAttribute.size() < 3:
					Global.darkShootAttribute[current_attr] = Global.availableAttributes_higher["tier1"][current_attr]
					#print("Attribut hinzugefügt:", current_attr, "=", Global.darkShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"circleball":
				if Global.availableAttributes_higher["tier1"].has(current_attr) and Global.circleShootAttribute.size() < 3:
					Global.circleShootAttribute[current_attr] = Global.availableAttributes_higher["tier1"][current_attr]
					#print("Attribut hinzugefügt:", current_attr, "=", Global.circleShootAttribute[current_attr])
					Global.expAmount -= addCost
				else:
					print("Attribut nicht gefunden:", current_attr)
			"chest":
				if Global.availableAttributes["tier1"].has(current_attr) and Global.ChestAttribute.size() < 3:
					Global.ChestAttribute[current_attr] = Global.availableAttributes["tier1"][current_attr]
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
		if old_key == "count" or old_key == "pierce_count" :
			if Global.availableAttributes_higher["tier1"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost 
			if Global.availableAttributes_higher["tier2"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost_higher[0] 
			if Global.availableAttributes_higher["tier3"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost_higher[0] + upgradeCost_higher[1]
		else :
			if Global.availableAttributes["tier1"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost 
			if Global.availableAttributes["tier2"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost[0]
			if Global.availableAttributes["tier3"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost[0] + upgradeCost[1]
			if Global.availableAttributes["tier4"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost[0] + upgradeCost[1] + upgradeCost[2]
			if Global.availableAttributes["tier5"][old_key] == dicRef[old_key]:
				Global.expAmount += addCost + upgradeCost[0] + upgradeCost[1] + upgradeCost[2] + upgradeCost[3]
			"""if availableAttributes_Armor["tier1"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier2"][old_key]
				Global.expAmount -= 5
			if availableAttributes_Armor["tier2"][old_key] == dicRef[old_key]:
				new_value = availableAttributes_Armor["tier3"][old_key]
				Global.expAmount -= 10"""
			# Ersetze das Attribut mit dem neuen Wert
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
		"""for key in dicRef.keys():
			print("%s: %s" % [key, str(dicRef[key])])"""


func UpgradeTierAttr2(dicRef: Dictionary ):
	var keys = dicRef.keys()
	if posInDic >= keys.size():
		print("Ungültige Position im Dictionary.")
		return

	var old_key = keys[posInDic]
	print("-----",posInDic)
	print("---------",keys[posInDic])
	var tier = ""
	var cost = 0
	var higher = false

	# Bestimme, in welchem Tier das aktuelle Attribut ist
	if Global.availableAttributes["tier1"].has(old_key) and dicRef[old_key] == Global.availableAttributes["tier1"][old_key]:
		tier = "tier2"
		cost = upgradeCost[0]
	elif Global.availableAttributes["tier2"].has(old_key) and dicRef[old_key] == Global.availableAttributes["tier2"][old_key]:
		tier = "tier3"
		cost = upgradeCost[1]
	elif Global.availableAttributes["tier3"].has(old_key) and dicRef[old_key] == Global.availableAttributes["tier3"][old_key]:
		tier = "tier4"
		cost = upgradeCost[2]
	elif Global.availableAttributes["tier4"].has(old_key) and dicRef[old_key] == Global.availableAttributes["tier4"][old_key]:
		tier = "tier5"
		cost = upgradeCost[3]
	elif Global.availableAttributes_higher["tier1"].has(old_key) and dicRef[old_key] == Global.availableAttributes_higher["tier1"][old_key]:
		tier = "tier2"
		higher = true
		cost = upgradeCost_higher[0] 
	elif Global.availableAttributes_higher["tier2"].has(old_key) and dicRef[old_key] == Global.availableAttributes_higher["tier2"][old_key]:
		tier = "tier3"
		higher = true
		cost = upgradeCost_higher[1] 
	else:
		print("Upgrade nicht möglich – Attribut ist schon auf maximalem Level oder ungültig.")
		return

	# Überprüfe EXP und führe das Upgrade durch
	if Global.expAmount >= cost:
		var new_value
		if higher :
			new_value = Global.availableAttributes_higher[tier][old_key]
			dicRef[old_key] = new_value
			higher = false
		else:
			new_value = Global.availableAttributes[tier][old_key]
			dicRef[old_key] = new_value
		Global.expAmount -= cost
		print("Upgrade durchgeführt:", old_key, "->", new_value, "| Rest-EXP:", Global.expAmount)
	else:
		print("Nicht genug EXP für Upgrade. Benötigt:", cost, " | Verfügbar:", Global.expAmount)
	for key in dicRef.keys():
		print("%s: %s" % [key, str(dicRef[key])])


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
		addAttrNormal()
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


func _on_add_attr_pressedHigher() -> void:
	print("----presthigher")
	if current_attr:
		addAttrHigher()
		spawnUI.DoDetails()
