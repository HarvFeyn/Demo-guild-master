extends Control

var createPlayer: Node

func _init() -> void:
	if(!global_data.statNpcList.has(0)):
		global_data.statNpcList[0] = null

func _ready() -> void: 
	if(!global_data.statNpcList[0]):
		$HBoxContainer.visible = false
		createPlayer = add_child_to_current_scene("uid://c8rev7nn1yxor")
	else:
		displayPlayer()
		for char: int in global_data.statNpcList:
			if(!char==0):
				add_char_to_characters(char)
	EventBus.deleteMeDaddy.connect(player_create)
	EventBus.charCardClick.connect(charSelected)
	EventBus.kickChar.connect(kickChar)
	global_data.selectedTeam = {}
	global_data.selectedTeam[0] = 0
	

func _process(delta: float) -> void:
	pass

func add_child_to_current_scene(filepath: String) -> Node:
	var packed_scene: PackedScene = load(filepath)
	var instance: Node = packed_scene.instantiate()
	get_tree().current_scene.add_child(instance)
	return instance

func player_create() -> void:
	get_tree().current_scene.remove_child(createPlayer)
	displayPlayer()

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("uid://b8j4tmq5qo4f0")
	
func add_player_to_characters() -> void:
	var filepath: String = "uid://cr6ru7nhhudnb"
	var packed_scene: PackedScene = load(filepath)
	var instance: Node = packed_scene.instantiate()
	instance.idChar = 0
	global_data.nodeNpcList[0]=instance
	$HBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer.add_child(instance)

func add_char_to_characters(id: int) -> void:
	if(!id==0):
		var filepath: String = "uid://cr6ru7nhhudnb"
		var packed_scene: PackedScene = load(filepath)
		var instance: Node = packed_scene.instantiate()
		instance.idChar = id
		global_data.nodeNpcList[id]=instance
		$HBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer2.add_child(instance)

func remove_char_from_characters(id: int) -> void:
	if(!id==0):
		var instance: Node = global_data.nodeNpcList[id]
		$HBoxContainer/MarginContainer/PanelContainer/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer2.remove_child(instance)
		instance.queue_free()
	
func displayPlayer() -> void:
	$HBoxContainer.visible = true
	add_player_to_characters()
	addNameToSelectedList(0)

func _on_donjon_1_pressed() -> void:
	startDungeon(1)

func _on_donjon_2_pressed() -> void:
	startDungeon(2)

func _on_donjon_3_pressed() -> void:
	startDungeon(3)

func startDungeon(difficulty: int) -> void:
	$HBoxContainer.visible = false
	$PanelContainer.visible = true
	global_data.gainXpSelected(difficulty*difficulty*100)
	EventBus.emit_signal("refreshCharData")
	var newChar: CharStats = CharStats.new(DungeonResolver.generate_hero_name(),DungeonResolver.generate_hero_class())
	global_data.statNpcList[newChar.idChar] = newChar
	add_char_to_characters(newChar.idChar)
	refreshPalyerInSelectedList()

func charSelected(id: int) -> void:
	if(global_data.selectedTeam.has(id)):
		global_data.selectedTeam.erase(id)
		var label: Node = $HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer.get_node_or_null(str(id))
		if(label):
			label.queue_free()
	else:
		global_data.selectedTeam[id] = id
		addNameToSelectedList(id)
	$HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/nombreDeJoeur.text = "( " + str(global_data.selectedTeam.size()) + " / 5 ) Joueurs"

func addNameToSelectedList(id: int) -> void:
	var label: Node = Label.new()
	label.name = str(id)
	label.text = global_data.statNpcList[id].charName + " - " + global_data.statNpcList[id].EnumCharClass.keys()[global_data.statNpcList[id].charClass] + " - lvl " + str(global_data.statNpcList[id].level)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer.add_child(label)

func _on_finish_dungeon_pressed() -> void:
	$HBoxContainer.visible = true
	$PanelContainer.visible = false

func refreshPalyerInSelectedList() -> void:
	for id: int in global_data.selectedTeam:
		var label: Node = $HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer.get_node_or_null(str(id))
		if(label):
			label.free()
		addNameToSelectedList(id)

func kickChar(id: int) -> void:
	global_data.statNpcList.erase(id)
	if(global_data.selectedTeam.has(id)):
		global_data.selectedTeam.erase(id)
		var label: Node = $HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/VBoxContainer.get_node_or_null(str(id))
		if(label):
			label.queue_free()
		$HBoxContainer/MarginContainer2/VBoxContainer/PanelContainer2/ScrollContainer/MarginContainer/VBoxContainer/nombreDeJoeur.text = "( " + str(global_data.selectedTeam.size()) + " / 5 ) Joueurs"
	remove_char_from_characters(id)
