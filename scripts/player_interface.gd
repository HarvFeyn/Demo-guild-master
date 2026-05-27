extends Control

var idChar: int

@export var style_normal: StyleBox
@export var style_selected: StyleBox

var is_selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(idChar==0):
		$MarginContainer/VBoxContainer/Kick.visible = false
		is_selected = !is_selected
		_update_style()
	gui_input.connect(_on_gui_input)
	EventBus.refreshCharData.connect(displayPlayerInfo)
	$MarginContainer/VBoxContainer/PlayerName.text = global_data.statNpcList[idChar].charName
	displayPlayerInfo()

func displayPlayerInfo() -> void:
	displayPlayerLvl()
	displayPlayerClass()
	displayPlayerMaxHealth()
	displayPlayerPower()
	displayPlayerDefense()

func displayPlayerLvl() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerLvl.text = "Lvl " + str(global_data.statNpcList[idChar].level)

func displayPlayerClass() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerClass.text = "Classe : " + str(global_data.statNpcList[idChar].EnumCharClass.keys()[global_data.statNpcList[idChar].charClass])

func displayPlayerMaxHealth() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerMaxHealth.text = "PV max : " + str(global_data.statNpcList[idChar].current_max_health)

func displayPlayerPower() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerPower.text = "Puissance : " + str(global_data.statNpcList[idChar].current_power)

func displayPlayerDefense() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerDefense.text = "Defense : " + str(global_data.statNpcList[idChar].current_defense)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if(idChar!=0):
				is_selected = !is_selected
				_update_style()
				EventBus.charCardClick.emit(idChar)

func _update_style() -> void:
	if is_selected:
		add_theme_stylebox_override("panel", style_selected)
	else:
		add_theme_stylebox_override("panel", style_normal)

func _on_kick_pressed() -> void:
	EventBus.kickChar.emit(idChar)
