extends PanelContainer

@onready var invalid_name: Node = $MarginContainer/VBoxContainer/invalidName
@onready var name_input: Node = $MarginContainer/VBoxContainer/NameInput
@onready var tank_check: Node = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TankCheck
@onready var dps_check: Node = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DPSCheck
@onready var heal_check: Node = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HealCheck

var classOfTheChar: CharStats.EnumCharClass = CharStats.EnumCharClass.TANK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invalid_name.visible = false
	tank_check.button_pressed = true
	name_input.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_validate_pressed() -> void:
	var newName: String = name_input.get_text()
	if newName.length() > 1:
		var player: CharStats = CharStats.new(newName,classOfTheChar)
		global_data.statNpcList[0] = player
		EventBus.emit_signal("deleteMeDaddy")
	else:
		invalid_name.visible = true

func _on_tank_check_pressed() -> void:
	tank_check.button_pressed = true
	dps_check.button_pressed = false
	heal_check.button_pressed = false
	classOfTheChar = CharStats.EnumCharClass.TANK
	
func _on_dps_check_pressed() -> void:
	tank_check.button_pressed = false
	dps_check.button_pressed = true
	heal_check.button_pressed = false
	classOfTheChar = CharStats.EnumCharClass.DPS
	
func _on_heal_check_pressed() -> void:
	tank_check.button_pressed = false
	dps_check.button_pressed = false
	heal_check.button_pressed = true
	classOfTheChar = CharStats.EnumCharClass.HEALER
	
