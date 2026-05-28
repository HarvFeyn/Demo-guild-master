extends Node

var hbox: Node
var panel_dungeon: Node
var char_spawner: Node
var team_manager: Node
var game_scene: Node

@onready var is_sucess_label: Node = $"../PanelContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Label2"
@onready var xp_gain: Node = $"../PanelContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Label3"
@onready var no_xp_gain: Node = $"../PanelContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Label4"

func _ready() -> void:
	game_scene = $".."
	EventBus.invitChar.connect(_on_invit)
	
func start_dungeon(difficulty: int) -> void:
	game_scene.show_screen(global_data.Screen.DUNGEON)
	var xp_from_difficulty: int = difficulty*difficulty*100
	var isSuccess: bool = resolve_dungeon(difficulty)
	if(isSuccess):
		is_sucess_label.text = "C'est gagné !"
		xp_gain.text = "Les personnages de votre équipe gagnes " + str(xp_from_difficulty) + " d'xp."
		no_xp_gain.text = ""
		global_data.gainXpSelected(xp_from_difficulty)
		#char_spawner.add_char_card(newChar.idChar,global_data.Screen.DUNGEON)
		#char_spawner.add_char_card(newChar.idChar,global_data.Screen.TEAM_MANAGER)
	else:
		is_sucess_label.text = "C'est perdu gros noob !"
		xp_gain.text = ""
		no_xp_gain.text = "Aucune xp gagnée en cas de défaite"
	print("ploop")
	EventBus.emit_signal("refreshCharData")
	print("plaaap")
	team_manager.refresh_selected_list()
	print("splouch")

func finish_dungeon() -> void:
	print("char List : ")
	print(global_data.statNpcList)
	for npc: int in global_data.statNpcList:
		print("hero : " + str(npc))
		if(global_data.nodeGroupList.has(npc)):
			var instance: Node = global_data.nodeGroupList[npc]
			instance.queue_free()
			print(global_data.nodeGroupList[npc])
			global_data.nodeGroupList.erase(npc)
	game_scene.show_screen(global_data.Screen.TEAM_MANAGER)

func resolve_dungeon(difficulty: int) -> bool:
	var turn: int = 1
	var dungeon_sucess: bool = false
	var boss_hp: int = difficulty*difficulty*100
	var boss_attack: int
	var boss_defense: int = difficulty*difficulty*2
	var group: Dictionary = global_data.selectedTeam.duplicate()
	while (group.size()<5):
		var newChar: CharStats = CharStats.new(DungeonResolver.generate_hero_name(),DungeonResolver.generate_hero_class())
		global_data.statNpcList[newChar.idChar] = newChar
		group[newChar.idChar]=newChar.idChar
	for hero: int in group:
		char_spawner.add_char_card(hero,global_data.Screen.DUNGEON)
	while (boss_hp>0 and group.size()>0):
		boss_attack = difficulty*difficulty*turn*1
		var target_heal: int = find_target_heal(group)
		var target_boss: int = find_target_boss(group)
		for hero: int in group:
			if(!global_data.statNpcList[hero].charClass == CharStats.EnumCharClass.HEALER):
				print("Attaque de " + str(global_data.statNpcList[hero].charName) +  " a " + str(global_data.statNpcList[hero].current_power))
				boss_hp -= global_data.statNpcList[hero].current_power
			else:
				print("Heal de " + str(global_data.statNpcList[hero].charName) + " de " + str(global_data.statNpcList[hero].current_power))
				global_data.statNpcList[target_heal].health += global_data.statNpcList[hero].current_power
		print("boss hp : " + str(boss_hp))
		print("HP de : " + str(global_data.statNpcList[target_boss].charName) + " " + str(global_data.statNpcList[target_boss].health))
		global_data.statNpcList[target_boss].take_damage(boss_attack)
		print("HP de : " + str(global_data.statNpcList[target_boss].charName) + " " + str(global_data.statNpcList[target_boss].health))
		if(global_data.statNpcList[target_boss].health<=0):
			group.erase(target_boss)
			print(group)
		turn+=1
	if(boss_hp<=0):
		print("Boss mort")
		dungeon_sucess = true
	else:
		print("Groupe mort")
		dungeon_sucess = false
	print("Fin du combat")
	for hero: int in global_data.selectedTeam:
		print("On remet " + str(global_data.statNpcList[hero].charName + " full vie, il avait " + str(global_data.statNpcList[hero].health)))
		global_data.statNpcList[hero].health = global_data.statNpcList[hero].current_max_health
		print("On a remi " + str(global_data.statNpcList[hero].charName + " full vie : " + str(global_data.statNpcList[hero].health)))
	return dungeon_sucess

func find_target_boss(group: Dictionary) -> int:
	var target: int = 0
	for hero: int in group:
		if(global_data.statNpcList[hero].health>global_data.statNpcList[target].health):
			target = hero
	return target
	
func find_target_heal(group: Dictionary) -> int:
	var target: int = 0
	for hero: int in group:
		if(global_data.statNpcList[hero].health<global_data.statNpcList[target].health):
			target = hero
	return target

func _on_invit(id:int) -> void:
	game_scene.show_screen(global_data.Screen.TEAM_MANAGER)
	global_data.statNpcList[id].is_guilded = true
	char_spawner.add_char_card(id,global_data.Screen.TEAM_MANAGER)
	finish_dungeon()
