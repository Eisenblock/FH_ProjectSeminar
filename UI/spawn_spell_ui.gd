extends Node2D

@export var textObject : PackedScene
@export var CircleObjectUI : PackedScene
@export var buttonObject : PackedScene
@export var buttonObject2 : PackedScene
@onready var label: Label = $"../Label"

var textInstances : Array 
var last_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var current_attribute : Dictionary = {}  # Speichert das letzte globale Dictionary
var last_attribute_hash = ""  # Variable zum Speichern der letzten Version des Dictionaries
var trackAutoAttrPos : int = -1
var trackCircleAttrPos : int = -1
var isInInterface : bool = false
var i = 0
#ppaceHolder
var isSwitch : bool = false

@onready var v_box_container: Control = $"../Control"



func _ready() -> void:
	current_attribute = Global.ChestAttribute


func updateTextFields():
	# Entfernen von allen vorherigen Textobjekten
	for child in get_children():
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

func updateTextFieldsRef(dicRef : Dictionary,name : String , countAttr : int ):
	# Entfernen von allen vorherigen Textobjekten
	var button_edit
	
	if name == "autoShoot" :
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
				var text_instance = textObject.instantiate()  # Erstellen eines neuen Textfeldes
				textInstances.append(textInstances)
				var text_edit = text_instance.get_node("Label") if text_instance.has_node("Label") else null
				button_edit = text_instance.get_node("Button") if text_instance.has_node("Button") else null
				var button_edit2 = text_instance.get_node("Button2") if text_instance.has_node("Button2") else null
				button_edit.posInDic = trackAutoAttrPos
				button_edit2.posInDic = trackAutoAttrPos
				text_edit.z_index = 1
				button_edit.z_index = 1
				button_edit2.z_index = 1
				trackAutoAttrPos += 1
				print("Peeeeeeeeeeeenes")
				print("pos INdic",button_edit.posInDic)
				v_box_container.add_child(text_instance)
				# Setze den Text des Textfeldes
				var string_value = "%.2f" % value
				text_edit.text = str(key) + " = " + str(string_value)
				# Setze die Position des Textfeldes (z. B. vertikal ansteigend)
				text_instance.position = Vector2(-511.0, -310.0 + y_offset) # Position auf der X-Achse und veränderte Y-Position
				if i == dicRef.keys().size() and countAttr < 5 :
					var button_instance = buttonObject.instantiate()
					v_box_container.add_child(button_instance)
					button_instance.position = Vector2(-511.0, -315.0 + y_offset)
				y_offset += 50  # Erhöht den Abstand für jedes neue Textfeld
				
	"""
	if name == "circleShoot" :
		for child in v_box_container.get_children():
			child.queue_free()
		trackCircleAttrPos = 0
		# Überprüfe das globale Dictionary
		if dicRef != null and dicRef.size() > 0:
			i = 0
			var y_offset = 0  # Um den Textfeld-Abstand vertikal zu steuern
			for key in dicRef.keys():
				i += 1
				var value = dicRef[key]
				var keys = dicRef.keys()
				# Instanziieren des TextEdit-Objekts
				var text_instance = CircleObjectUI.instantiate()  # Erstellen eines neuen Textfeldes
				textInstances.append(textInstances)
				var text_edit = text_instance.get_node("Label") if text_instance.has_node("Label") else null
				button_edit = text_instance.get_node("Button") if text_instance.has_node("Button") else null
				var button_edit2 = text_instance.get_node("Button2") if text_instance.has_node("Button2") else null
				button_edit.posInDic = trackCircleAttrPos
				button_edit2.posInDic= trackCircleAttrPos
				trackCircleAttrPos += 1
				text_edit.z_index = 1
				button_edit.z_index = 1
				button_edit2.z_index = 1
				v_box_container.add_child(text_instance)
				# Setze den Text des Textfeldes
				text_edit.text = str(key) + " = " + str(value)
				text_instance.position = Vector2(-511.0, -310.0 + y_offset) # Position auf der X-Achse und veränderte Y-Position
				if i == dicRef.keys().size() and countAttr < 5:
					var button_instance = buttonObject2.instantiate()
					v_box_container.add_child(button_instance)
					button_instance.position = Vector2(-511.0, -315.0 + y_offset)
					button_instance.z_index = 1
				y_offset += 50 
				"""
		# Speichern der aktuellen Version des Dictionaries als Hashwert
	last_attribute = dicRef

func _process(delta: float) -> void:
	#if isSwitch :
	#	!areDictionariesEqual(Global.autoShootAttribute,last_attribute)
	#	updateTextFieldsRef(Global.autoShootAttribute, "autoShoot")
	#else :
	#	!areDictionariesEqual(Global.circleShootAttribute,last_attribute)
	#	updateTextFieldsRef(Global.circleShootAttribute, "autoShoot")
	if Input.is_action_just_pressed("InterfacePlayer"):
		for child in get_children():
			child.queue_free()
		if !isInInterface :
			isInInterface = true
			v_box_container.visible = false
			get_tree().paused = true
			var arrayChild = get_tree().get_nodes_in_group("spell_ui")  # Spiel pausieren
			#arrayChild.process_mode = Node.PROCESS_MODE_ALWAYS 
		else :
			isInInterface = false
			v_box_container.visible = true
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
	updateTextFieldsRef(dicRef,name,countValue)
