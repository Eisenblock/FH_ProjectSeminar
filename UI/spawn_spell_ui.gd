extends Node2D
@onready var h_box_container: HBoxContainer = $"../CanvasLayer/HBoxContainer"
@onready var v_box_container: VBoxContainer = $"../CanvasLayer/VBoxContainer"

@export var textObject : PackedScene
@export var CircleObjectUI : PackedScene
@export var buttonObject : PackedScene
@export var buttonObject2 : PackedScene
@onready var label: Label = $"../CanvasLayer/Label"
@export var UI_Auto : PackedScene = load("res://UI/controlAuto.tscn")
@export var UI_Auto_Button : PackedScene = load("res://UI/button_dmgAuto.tscn")
@export var UI_Auto_Show_Button : PackedScene = load("res://UI/button_ShowAuto.tscn")
@export var UI_Fire_Show_Button : PackedScene = load("res://UI/button_ShowFire.tscn")
@export var UI_dark_Show_Button : PackedScene = load("res://UI/button_ShowDark.tscn")
@export var UI_Circle_Show_Button : PackedScene = load("res://UI/button_ShowCircle.tscn")
@export var UI_chest_Show_Button : PackedScene = load("res://UI/button_ShowChest.tscn")
var textInstances : Array 
var last_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var current_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var last_attribute_hash = ""  # Variable zum Speichern der letzten Version des Dictionaries
var trackAutoAttrPos : int = -1
var trackCircleAttrPos : int = -1
var isInInterface : bool = false
var i = 0
var a = 0
#ppaceHolder
var isSwitch : bool = false

@onready var box_container: Control = $"../CanvasLayer/Control"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var control_3: Control = $"../CanvasLayer/Control3"
@onready var canvas_layer_2: CanvasLayer = $"../CanvasLayer2"
@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"
@onready var directional_light_2d: DirectionalLight2D = $"../DirectionalLight2D"


var availableAttributes = {
	
	"tier1": {
		"base_dmg": 2,    
		"pierce"  : 1,  
		"size"  : 1,  
		"more_projectiles": 1,   
		"attack_speed": 0.2,     
		"lifetime": 0.5,         
			},
	"tier2": {
		"base_dmg": 4,      
		"pierce"  : 2,  
		"size"  : 2,      
		"more_projectiles": 2,   
		"attack_speed": 0.5,     
		"lifetime": 0.7,         
			},
	"tier3": {
		"base_dmg": 8,    
		"pierce"  : 3,  
		"size"  : 3,     
		"more_projectiles": 3,   
		"attack_speed": 0.8,     
		"lifetime": 0.9,         
			}
	}


func _ready() -> void:
	current_attribute = Global.ChestAttribute
	#updateTextFieldsRef(Global.autoShootAttribute, "autoShoot",Global.countAttrOnAuto,UI_Auto,UI_Auto_Button)
	if Global.learned_abilities.has("fireball"):
		SpawmButtonShow(UI_Fire_Show_Button)
	if Global.learned_abilities.has("circleball"):
		SpawmButtonShow(UI_Circle_Show_Button)
	if Global.learned_abilities.has("darkball"):
		SpawmButtonShow(UI_dark_Show_Button)
	if Global.learned_abilities.has("auto"):
		SpawmButtonShow(UI_Auto_Show_Button)

	#updateTextFieldsRef(current_attribute,"autoShoot",Global.countAttrOnAuto)

func SpawmButtonShow(buttonRef):
	var button_instance = buttonRef.instantiate()
	h_box_container.add_child(button_instance)
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
			if availableAttributes["tier1"][key] == dicRef[key]:
				button_edit.upgradeCost = 10
			if availableAttributes["tier2"][key] == dicRef[key]:
				button_edit.upgradeCost = 15
			if availableAttributes["tier2"][key] == dicRef[key]:
				button_edit.upgradeCost = 0
			v_box_container.add_child(text_instance)
			# Setze den Text des Textfeldes
			var string_value = "%.2f" % value
			text_edit.text = str(key) + " = " + str(string_value)
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
	#if isSwitch :
	#	!areDictionariesEqual(Global.autoShootAttribute,last_attribute)
	#	updateTextFieldsRef(Global.autoShootAttribute, "autoShoot")
	#else :
	#	!areDictionariesEqual(Global.circleShootAttribute,last_attribute)
	#	updateTextFieldsRef(Global.circleShootAttribute, "autoShoot")
	var valuestr = Global.expAmount
	label.text = str(valuestr)
	
	if Input.is_action_just_pressed("InterfacePlayer"):
		for child in get_children():
			child.queue_free()
		if !isInInterface :
			isInInterface = true
			canvas_layer.visible = true
			var arrayChild = get_tree().get_nodes_in_group("spell_ui")  # Spiel pausieren
			get_tree().paused = true
		else :
			isInInterface = false
			canvas_layer.visible = false
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

func SwitchAttribute(dicRef : Dictionary, name : String, countValue : int):
	current_attribute = dicRef
	#updateTextFieldsRef(dicRef,name,countValue)
