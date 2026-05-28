extends Control

var create_player_scene: Node

@onready var char_spawner: Node = $CharSpawner
@onready var team_manager: Node = $TeamManager
@onready var dungeon_manager: Node = $DungeonManager
@onready var char_container_player: Node = $HBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer
@onready var char_container_npc: Node = $HBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer2
@onready var char_container_recrue: Node = $PanelContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
@onready var selected_list_container: Node = $HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer
@onready var label_nombre_joueurs: Node = $HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/nombreDeJoeur
@onready var hbox: Node = $HBoxContainer
@onready var panel_dungeon: Node = $PanelContainer

const ConfirmationPopup: Resource = preload("uid://coke752lxlv4o")

func _init() -> void:
	if(!global_data.statNpcList.has(0)):
		global_data.statNpcList[0] = null

func _ready() -> void: 
	char_spawner.container_player = char_container_player
	char_spawner.container_npc = char_container_npc
	char_spawner.container_recrue = char_container_recrue
	team_manager.selected_list_container = selected_list_container
	team_manager.label_count = label_nombre_joueurs
	dungeon_manager.hbox = hbox
	dungeon_manager.panel_dungeon = panel_dungeon
	dungeon_manager.char_spawner = char_spawner
	dungeon_manager.team_manager = team_manager
	
	create_player_scene = _spaw_scene("uid://c8rev7nn1yxor")
	
	EventBus.deleteMeDaddy.connect(_on_player_create)
	EventBus.charCardClick.connect(_on_char_selected)
	EventBus.kickChar.connect(ask_delete_char)
	
	global_data.selectedTeam = {}
	global_data.selectedTeam[0] = 0
	
	if(!global_data.statNpcList[0]):
		show_screen(global_data.Screen.CREATE_PLAYER)
	else:
		_display_all_chars()

func _spaw_scene(filepath: String) -> Node:
	var instance: Node = load(filepath).instantiate()
	get_tree().current_scene.add_child(instance)
	return instance

func _on_player_create() -> void:
	get_tree().current_scene.remove_child(create_player_scene)
	show_screen(global_data.Screen.TEAM_MANAGER)
	char_spawner.add_char_card(0,global_data.Screen.TEAM_MANAGER)
	team_manager.add_name_to_selected_list(0)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("uid://b8j4tmq5qo4f0")

func _on_donjon_1_pressed() -> void:
	dungeon_manager.start_dungeon(1)

func _on_donjon_2_pressed() -> void:
	dungeon_manager.start_dungeon(2)

func _on_donjon_3_pressed() -> void:
	dungeon_manager.start_dungeon(3)

func _on_char_selected(id: int) -> void:
	team_manager.toggle_char_selection(id)

func _on_finish_dungeon_pressed() -> void:
	dungeon_manager.finish_dungeon()

func _on_kickChar(id: int) -> void:
	global_data.statNpcList.erase(id)
	team_manager.remove_name_from_selected_list(id)
	char_spawner.remove_char_card(id)

func ask_delete_char(id: int) -> void:
	var popup: Node = ConfirmationPopup.instantiate()
	popup.setup("Virer " + global_data.statNpcList[id].charName + " de la guilde ?")
	add_child(popup)
	popup.confirmed.connect(func()->void: _on_kickChar(id))
	popup.cancelled.connect(func()->void: pass)

func _display_all_chars() -> void:
	show_screen(global_data.Screen.TEAM_MANAGER)
	for id: int in global_data.statNpcList:
		if(global_data.statNpcList[id].is_guilded == true):
			char_spawner.add_char_card(id,global_data.Screen.TEAM_MANAGER)
			if global_data.selectedTeam.has(id):
				team_manager.add_name_to_selected_list(id)

func show_screen(screen: global_data.Screen) -> void:
	global_data.current_screen = screen
	hbox.visible = screen == global_data.Screen.TEAM_MANAGER
	panel_dungeon.visible = screen == global_data.Screen.DUNGEON
	create_player_scene.visible = screen == global_data.Screen.CREATE_PLAYER
