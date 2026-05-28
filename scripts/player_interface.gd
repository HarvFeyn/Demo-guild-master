extends Control

var idChar: int

@export var style_normal: StyleBox
@export var style_selected: StyleBox

var is_selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(idChar==0):
		is_selected = true
		$MarginContainer/VBoxContainer/PanelContainer/Kick.visible = false
		$MarginContainer/VBoxContainer/PanelContainer/Invite.visible = false
	gui_input.connect(_on_gui_input)
	EventBus.refreshCharData.connect(displayPlayerInfo)
	$MarginContainer/VBoxContainer/PlayerName.text = global_data.statNpcList[idChar].charName
	displayPlayerInfo()
	_update_style()

func displayPlayerInfo() -> void:
	displayPlayerLvl()
	displayPlayerClass()
	displayPlayerMaxHealth()
	displayPlayerPower()
	displayPlayerDefense()

func displayPlayerLvl() -> void:
	print("WTF : " + str(idChar))
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
			if(idChar!=0 and global_data.current_screen == global_data.Screen.TEAM_MANAGER):
				is_selected = !is_selected
				_update_style()
				EventBus.charCardClick.emit(idChar)

func _update_style() -> void:
	print("i am ready")
	print(global_data.current_screen)
	if(global_data.current_screen == global_data.Screen.DUNGEON):
		is_selected = false
		$MarginContainer/VBoxContainer/PanelContainer/Kick.visible = false
		if(global_data.statNpcList[idChar].is_guilded == true):
			$MarginContainer/VBoxContainer/PanelContainer/Invite.visible =  false
	if(global_data.statNpcList[idChar].is_guilded == true and global_data.current_screen == global_data.Screen.TEAM_MANAGER and idChar!=0):
		$MarginContainer/VBoxContainer/PanelContainer/Kick.visible = true
		$MarginContainer/VBoxContainer/PanelContainer/Invite.visible =  false
	if (is_selected and global_data.current_screen == global_data.Screen.TEAM_MANAGER):
		add_theme_stylebox_override("panel", style_selected)
	else:
		add_theme_stylebox_override("panel", style_normal)

func _on_kick_pressed() -> void:
	EventBus.kickChar.emit(idChar)

func _on_invite_pressed() -> void:
	EventBus.invitChar.emit(idChar)
