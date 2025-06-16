extends Node2D
@onready var h_box_container: VBoxContainer = $"../CanvasLayer/HBoxContainer"
@onready var v_box_container: VBoxContainer = $"../CanvasLayer/VBoxContainer"

@export var textObject : PackedScene
@export var CircleObjectUI : PackedScene
@export var buttonObject : PackedScene
@export var buttonObject2 : PackedScene
@onready var exp_points: Label = $"../CanvasLayer/ExpPoints"
@onready var v_box_container_2: VBoxContainer = $"../CanvasLayer/VBoxContainer2"
@export var UI_Details_text = load("res://UI/UI_SkillSystem/DetailsValue.tscn")
@export var UI_Details_text_emphty = load("res://UI/UI_SkillSystem/DetailsValue_empthy.tscn")
@export var UI_Details_text_emphty_higher = load("res://UI/UI_SkillSystem/DetailsValue_empthy_higher.tscn")
@export var UI_Auto : PackedScene = load("res://UI/controlAuto.tscn")
@export var UI_Auto_Button : PackedScene = load("res://UI/button_dmgAuto.tscn")
@export var UI_Auto_Show_Button : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowAuto.tscn")
@export var UI_Auto_Show_Button_empty : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowAuto_empty.tscn")
@export var UI_Fire_Show_Button : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowFire.tscn")
@export var UI_Fire_Show_Button_empty : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowFire_empty.tscn")
@export var UI_dark_Show_Button : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowDark.tscn")
@export var UI_dark_Show_Button_empty : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_Showdark_empty.tscn")
@export var UI_Circle_Show_Button : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowCircle.tscn")
@export var UI_circle_Show_Button_empty : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowCircle_empty.tscn")
@export var UI_chest_Show_Button : PackedScene = load("res://UI/UI_SkillSystem/UI_Abilitys/button_ShowChest.tscn")
@onready var cd_timer_box: HBoxContainer = $"../UI_DuringPlayTime/Cd_TimerBox"
@onready var avaible_ability: VBoxContainer = $"../CanvasLayer/avaibleAbility"

var UITimerDark : PackedScene = load("res://cd_timer_ShowUI.tscn")
var UITImerAuto: PackedScene = load("res://cd_timerFire_ShowUI.tscn")
var UITImerCircle: PackedScene = load("res://cd_timercircle_ShowUI.tscn")
var UITimerFire : PackedScene= load("res://cd_timerAuto_ShowUI.tscn")
var details_Object
var upgradeCost = [5,10,15,20,"Max"]
var upgradeCost_higher = [10,20,"Max"]
#Bool Track current Dic
var current_Dic_name = ""
var DicTier1 = {}
var DicTier1_higher = {}
var textInstances : Array 
var last_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var current_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var last_attribute_hash = ""  # Variable zum Speichern der letzten Version des Dictionaries
var trackAutoAttrPos : int = -1
var trackCircleAttrPos : int = -1
var isInInterface : bool = false
var cost_type_upgrade = 0
var i = 0
var a = 0
var b = 0
#ppaceHolder
var isSwitch : bool = false
var DicTier2
@onready var box_container: Control = $"../CanvasLayer/Control"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var control_3: Control = $"../CanvasLayer/Control3"
@onready var canvas_layer_2: CanvasLayer = $"../CanvasLayer2"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
@onready var directional_light_2d: DirectionalLight2D = $"../DirectionalLight2D"


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
func _ready() -> void:
	DoDetails()
	SetTimerAbility()
	current_attribute = Global.ChestAttribute
	#updateTextFieldsRef(Global.autoShootAttribute, "autoShoot",Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
	if Global.learned_abilities.has("fireball"):
		SpawmButtonShow(UI_Fire_Show_Button)
	else :
		SpawmButtonShow(UI_Fire_Show_Button_empty)
	if Global.learned_abilities.has("circleball"):
		SpawmButtonShow(UI_Circle_Show_Button)
	else :
		SpawmButtonShow(UI_circle_Show_Button_empty)
	if Global.learned_abilities.has("darkball"):
		SpawmButtonShow(UI_dark_Show_Button)
	else :
		SpawmButtonShow(UI_dark_Show_Button_empty)
	if Global.learned_abilities.has("auto"):
		SpawmButtonShow(UI_Auto_Show_Button)
	else :
		SpawmButtonShow(UI_Auto_Show_Button_empty)

	#updateTextFieldsRef(current_attribute,"autoShoot",Global.countAttrOnAuto)

func SpawmButtonShow(buttonRef):
	var button_instance = buttonRef.instantiate()
	avaible_ability.add_child(button_instance)
	#button_instance.position = Vector2(-355.0, -158.0 + 0)
	button_instance.position = Vector2(100.0 + a * 60, -158.0 )
	button_instance.scale = Vector2(0.2, 0.2)
	a += 1
	button_instance.add_to_group("keep")

func DoGameOver():
	canvas_layer_2.visible = true
	canvas_modulate.color = Color(1, 1, 1, 1) # Start: Weiß
	var tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 0.8), 1.5)
	directional_light_2d.visible = false
	get_tree().paused = true

func updateTextFields():
	# Entfernen von allen vorherigen Textobjekten
	for child in v_box_container.get_children():
		if not child.is_in_group("keep"):
			child.queue_free()

	# Überprüfe das globale Dictionary
	if Global.autoShootAttribute != null and Global.autoShootAttribute.size() > 0:
		
		var y_offset = 0  # Um den Textfeld-Abstand vertikal zu steuern
		for key in Global.autoShootAttribute.keys():
			var value = Global.autoShootAttribute[key]
			var keys = Global.autoShootAttribute.keys()
			# Instanziieren des TextEdit-Objekts
			var text_instance = textObject.instantiate()  # Erstellen eines neuen Textfeldes
			textInstances.append(textInstances)
			var text_edit = text_instance.get_node("Label") if text_instance.has_node("Label") else null
			v_box_container.add_child(text_instance)
			# Setze den Text des Textfeldes
			text_edit.text = str(key) + " = " + str(value)

			# Setze die Position des Textfeldes (z. B. vertikal ansteigend)
			text_instance.position = Vector2(-511.0, -310.0 + y_offset)  # Position auf der X-Achse und veränderte Y-Position
			
			y_offset += 50  # Erhöht den Abstand für jedes neue Textfeld
			
	# Speichern der aktuellen Version des Dictionaries als Hashwert
	last_attribute = Global.autoShootAttribute.duplicate()

func areDictionariesEqual(dict1: Dictionary, dict2: Dictionary) -> bool:
   # Vergleiche die Größe der beiden Dictionaries
	if dict1.size() != dict2.size():
		return false

	# Vergleiche die Schlüssel und Werte der beiden Dictionaries
	for key in dict1.keys():
		if dict1[key] != dict2.get(key, null):
			return false

	return true

func updateTextFieldsRef(dicRef : Dictionary,name : String , countAttr : int , sceneRef : PackedScene, buttonRef : PackedScene):
	# Entfernen von allen vorherigen Textobjekten
	var button_edit
	DoDetails()
	for child in v_box_container.get_children():
		child.queue_free()
	trackAutoAttrPos = 0
	i = 0
		# Überprüfe das globale Dictionary
	if dicRef != null and dicRef.size() > 0:
		var y_offset = 0  # Um den Textfeld-Abstand vertikal zu steuern
		for key in dicRef.keys():
			i += 1
			var value = dicRef[key]
			var keys = dicRef.keys()
				# Instanziieren des TextEdit-Objekts
			var text_instance = sceneRef.instantiate()  # Erstellen eines neuen Textfeldes
			textInstances.append(textInstances)
			var text_edit = text_instance.get_node("Label") if text_instance.has_node("Label") else null
			button_edit = text_instance.get_node("Button") if text_instance.has_node("Button") else null
			var button_edit2 = text_instance.get_node("Button2") if text_instance.has_node("Button2") else null
			button_edit.posInDic = trackAutoAttrPos
			button_edit.changeCost = 1 + dicRef.size()
			button_edit2.posInDic = trackAutoAttrPos
			text_edit.z_index = 1
			button_edit.z_index = 1
			button_edit2.z_index = 1
			trackAutoAttrPos += 1
			if Global.availableAttributes.has(key):
				if Global.availableAttributes["tier1"][key] == dicRef[key]:
					button_edit.upgradeCost = 10
				if Global.availableAttributes["tier2"][key] == dicRef[key]:
					button_edit.upgradeCost = 15
				if Global.availableAttributes["tier3"][key] == dicRef[key]:
					button_edit.upgradeCost = 0
			if availableAttributes_Armor.has(key) :
				if availableAttributes_Armor["tier1"][key] == dicRef[key]:
					button_edit.upgradeCost = 5
				if availableAttributes_Armor["tier2"][key] == dicRef[key]:
					button_edit.upgradeCost = 10
				if availableAttributes_Armor["tier3"][key] == dicRef[key]:
					button_edit.upgradeCost = 0
			v_box_container.add_child(text_instance)
			# Setze den Text des Textfeldes
			print("UpgradeVlaue",value)
			var string_value = "%.2f" % value
			text_edit.text = str(key) + " = " + str(value)
				# Setze die Position des Textfeldes (z. B. vertikal ansteigend)
			#text_instance.position = Vector2(-355.0, -158.0 + y_offset) # Position auf der X-Achse und veränderte Y-Position
			if i == dicRef.keys().size() and countAttr < 4 :
				var button_instance = buttonRef.instantiate()
				#button_instance.scale = Vector2(0.5, 0.5)
				v_box_container.add_child(button_instance)
				#button_instance.position = Vector2(-355.0, -158.0 + y_offset)
				button_instance.position = Vector2(17, -37)
				button_instance.addCost = 5 + dicRef.size()
			y_offset += 50  # Erhöht den Abstand für jedes neue Textfeld
	else :
		var button_instance = buttonRef.instantiate()
		#button_instance.scale = Vector2(0.5, 0.5)
		v_box_container.add_child(button_instance)
		#button_instance.position = Vector2(-355.0, -158.0 + 0)
		button_instance.position = Vector2(17, -37)
		# Speichern der aktuellen Version des Dictionaries als Hashwert
	last_attribute = dicRef

func _process(delta: float) -> void:
	exp_points.text = str(Global.expAmount)
	
	if Input.is_action_just_pressed("InterfacePlayer"):
		for child in get_children():
			child.queue_free()
		if !isInInterface :
			isInInterface = true
			canvas_layer.visible = true
			cd_timer_box.visible = false
			var arrayChild = get_tree().get_nodes_in_group("spell_ui")  # Spiel pausieren
			get_tree().paused = true
		else :
			isInInterface = false
			canvas_layer.visible = false
			cd_timer_box.visible = true
			get_tree().paused = false
	"""
	if Input.is_action_just_pressed("TestInput"):
		#updateTextFieldsRef(current_attribute)
		if !isSwitch :
			SwitchAttribute(Global.circleShootAttribute, "autoShoot",Global.countAttrOnAuto)
			isSwitch = true
			label.text = "AutoShoot"
		else :
			SwitchAttribute(Global.autoShootAttribute,"circleShoot",Global.countAttrOnCircle)
			isSwitch = false
			label.text = "CircleShoot"
	"""
	



func SwitchAttribute(dicRef : Dictionary, name : String):
	current_attribute = dicRef
	current_Dic_name = name
	DoDetails()
	#updateTextFieldsRef(dicRef,name,countValue)
	

func DoDetails():
	var details_Object
	var children = v_box_container_2.get_children()
	for child in children :
		child.queue_free()
	DicTier1.clear()
	DicTier1 = Global.availableAttributes["tier1"].duplicate()
	DicTier1_higher = Global.availableAttributes_higher["tier1"].duplicate()
	b = 0
	match current_Dic_name :
		"auto" :
			PrintActiveAttr(Global.autoShootAttribute)
			DoEmpthyDetails(false,Global.autoShootAttribute)
			DoEmpthyDetails(true,Global.autoShootAttribute)
		"fireball" :
			PrintActiveAttr(Global.fireballShootAttribute)
			DoEmpthyDetails(false,Global.fireballShootAttribute)
			DoEmpthyDetails(true,Global.fireballShootAttribute)
		"circleball" :
			PrintActiveAttr(Global.circleShootAttribute)
			DoEmpthyDetails(false,Global.circleShootAttribute)
			DoEmpthyDetails(true,Global.circleShootAttribute)
		"darkball" :
			PrintActiveAttr(Global.darkShootAttribute)
			DoEmpthyDetails(false,Global.darkShootAttribute)
			DoEmpthyDetails(true,Global.darkShootAttribute)

func checkHigherTier(attr_dict: Dictionary,refkey):
	DicTier2.clear()
	DicTier2 = Global.all_availableAttributes["tier2"].duplicate()
	var key = refkey
	if DicTier2.has(refkey):
		# Überschreibt den Wert aus tier1 mit dem Benutzerwert
		if key == "count" or key == "pierce_count" :
			if Global.availableAttributes_higher["tier1"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes_higher["tier2"][key]
				cost_type_upgrade = 0
			elif Global.availableAttributes_higher["tier2"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes_higher["tier3"][key]
				cost_type_upgrade = 1
		else:
			if Global.availableAttributes["tier1"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes["tier2"][key]
				cost_type_upgrade = 0
			elif Global.availableAttributes["tier2"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes["tier3"][key]
				cost_type_upgrade = 1
			elif Global.availableAttributes["tier3"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes["tier4"][key]
				cost_type_upgrade = 2
			elif Global.availableAttributes["tier4"][key] == attr_dict[key]:
				DicTier2[key] = Global.availableAttributes["tier5"][key]
				cost_type_upgrade = 3
			else:
				DicTier2[key] = attr_dict[key]
	
	# Ausgabe oder UI-Anzeige aller Werte

	# Ausgabe oder UI-Anzeige aller Werte



func showAttributes(attr_dict: Dictionary):
	DicTier1.clear()
	DicTier1 = Global.availableAttributes["tier1"].duplicate()
	for key in attr_dict.keys():
		if DicTier1.has(key):
			DicTier1[key] = attr_dict[key]

func showAttributesHigher(attr_dict: Dictionary):
	DicTier1.clear()
	DicTier1 = Global.all_availableAttributes["tier1"].duplicate()
	for key in attr_dict.keys():
		if DicTier1.has(key):
			DicTier1[key] = attr_dict[key]

func printAll():
	print("___________________________------------______________________")
	for key in DicTier1.keys():
		print("%s: %s" % [key, str(DicTier1[key])])

func PrintActiveAttr(dicRef:Dictionary) :
	for attr in dicRef.keys():
		showAttributesHigher(dicRef)
		details_Object = UI_Details_text.instantiate()
		var nodeUpgradeButton = details_Object.get_node("HighetTier")
		DicTier2 = Global.availableAttributes["tier2"].duplicate()
		var DicTier2_higher = Global.availableAttributes_higher["tier2"].duplicate()
		checkHigherTier(dicRef,attr)
		if Global.availableAttributes["tier5"].has(attr) and Global.availableAttributes["tier5"][attr] == DicTier1[attr] or Global.availableAttributes_higher["tier3"].has(attr) and Global.availableAttributes_higher["tier3"][attr] == DicTier1[attr]:
			nodeUpgradeButton.text = "Max"
			nodeUpgradeButton.set_process(false)
			nodeUpgradeButton.release_focus()
			nodeUpgradeButton.focus_mode = Control.FOCUS_NONE
			nodeUpgradeButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			details_Object.posInDic = b
			b+=1
		else:
			if attr == "count" or attr == "pierce_count" :
				nodeUpgradeButton.text = "->%s\n\t->%s" % [str(DicTier2[attr]), str(upgradeCost_higher[cost_type_upgrade])]
				details_Object.addCost = 8
			else :
				nodeUpgradeButton.text = "->%s\n                   ->%s" % [str(DicTier2[attr]), str(upgradeCost[cost_type_upgrade])]
				details_Object.addCost = 4
			details_Object.posInDic = b
			b+=1
		var nodeDetailText = details_Object.get_node("Details_Text")
		if attr == "cooldown" :
			nodeDetailText.text = "%s: %s s" % [attr, str(DicTier1[attr])]
		elif attr == "count" or attr == "pierce_count" :
			nodeDetailText.text = "%s: %s" % [attr, str(DicTier1[attr])]
		else :
			nodeDetailText.text = "%s: %s" % [attr, str(DicTier1[attr])]
		var nodeResetButton = details_Object.get_node("Reset")
		details_Object.current_attr = attr
		details_Object.current_Dic = current_Dic_name
		v_box_container_2.add_child(details_Object)
	printAll()

func printDefaultAttr(dicRef : Dictionary,attr_ref):
	var details_Object
	showAttributes(Global.autoShootAttribute)
	if  !Global.autoShootAttribute.has(attr_ref) :
		details_Object = UI_Details_text_emphty.instantiate()
		var nodeDetailText = details_Object.get_node("Details_Text")
		nodeDetailText.text = "%s: %s" % [attr_ref, str(DicTier1[attr_ref])]
		details_Object.current_attr = attr_ref
		details_Object.current_Dic = current_Dic_name

func ClearDetails():
	var children = v_box_container_2.get_children()
	for child in children :
		child.queue_free()

func DoEmpthyDetails(refBool : bool,refDic_Global : Dictionary):
	var spawnObject 
	if !refBool :
		DicTier1.clear()
		DicTier1 = Global.availableAttributes["tier1"].duplicate()
		spawnObject = UI_Details_text_emphty
	else :
		DicTier1.clear()
		DicTier1 = Global.availableAttributes_higher["tier1"].duplicate()
		spawnObject = UI_Details_text_emphty_higher
	for attr in DicTier1.keys():
		if  !refDic_Global.has(attr) :
			details_Object = spawnObject.instantiate()
			var nodeDetailText = details_Object.get_node("Details_Text")
			var addButton = details_Object.get_node("AddAttr")
			if addButton :
				if attr == "count" or attr == "pierce_count" :
					details_Object.addCost = 8
				else :
					details_Object.addCost = 4
			if attr == "cooldown" :
				nodeDetailText.text = "%s: %s s" % [attr, str(DicTier1[attr])]
			else :
				nodeDetailText.text = "%s: %s" % [attr, str(DicTier1[attr])]
			details_Object.current_attr = attr
			details_Object.current_Dic = current_Dic_name
		v_box_container_2.add_child(details_Object)


func SetTimerAbility():
	var children = cd_timer_box.get_children()
	for child in children :
		child.queue_free()
	if Global.learned_abilities.has("fireball"):
		var instance = UITimerFire.instantiate()
		cd_timer_box.add_child(instance)
	if Global.learned_abilities.has("circleball"):
		var instance = UITImerCircle.instantiate()
		cd_timer_box.add_child(instance)
	if Global.learned_abilities.has("darkball"):
		var instance = UITimerDark.instantiate()
		cd_timer_box.add_child(instance)
	if Global.learned_abilities.has("auto"):
		var instance = UITImerAuto.instantiate()
		cd_timer_box.add_child(instance)
