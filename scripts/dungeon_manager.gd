extends Node

var hbox: Node
var panel_dungeon: Node
var char_spawner: Node
var team_manager: Node

func start_dungeon(difficulty: int) -> void:
	hbox.visible = false
	panel_dungeon.visible = true
	global_data.gainXpSelected(difficulty*difficulty*100)
	EventBus.emit_signal("refreshCharData")
	var newChar: CharStats = CharStats.new(DungeonResolver.generate_hero_name(),DungeonResolver.generate_hero_class())
	global_data.statNpcList[newChar.idChar] = newChar
	char_spawner.add_char_card(newChar.idChar)
	team_manager.refresh_selected_list()
	
func finish_dungeon() -> void:
	hbox.visible = true
	panel_dungeon.visible = false
