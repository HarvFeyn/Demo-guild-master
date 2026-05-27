extends PanelContainer

var classOfTheChar: CharStats.EnumCharClass = CharStats.EnumCharClass.TANK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/invalidName.visible = false
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TankCheck.button_pressed = true
	$MarginContainer/VBoxContainer/NameInput.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_validate_pressed() -> void:
	var newName: String = $MarginContainer/VBoxContainer/NameInput.get_text()
	if newName.length() > 1:
		var player: CharStats = CharStats.new(newName,classOfTheChar)
		global_data.statNpcList[0] = player
		EventBus.emit_signal("deleteMeDaddy")
	else:
		$MarginContainer/VBoxContainer/invalidName.visible = true


func _on_tank_check_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TankCheck.button_pressed = true
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DPSCheck.button_pressed = false
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HealCheck.button_pressed = false
	classOfTheChar = CharStats.EnumCharClass.TANK
	
func _on_dps_check_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TankCheck.button_pressed = false
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DPSCheck.button_pressed = true
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HealCheck.button_pressed = false
	classOfTheChar = CharStats.EnumCharClass.DPS
	
func _on_heal_check_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TankCheck.button_pressed = false
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/DPSCheck.button_pressed = false
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/HealCheck.button_pressed = true
	classOfTheChar = CharStats.EnumCharClass.HEALER
	
