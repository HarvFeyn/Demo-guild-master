extends Node

var container_player: Node
var container_npc: Node
var game_scene: Node
var container_recrue: Node

func add_char_card(id: int, scene: global_data.Screen) -> void:
	var instance: Node = load("uid://cr6ru7nhhudnb").instantiate()
	instance.idChar = id
	var container: Node 
	if(scene == global_data.Screen.TEAM_MANAGER):
		container = container_player if id == 0 else container_npc
		global_data.nodeNpcList[id]=instance
	elif(scene == global_data.Screen.DUNGEON):
		container = container_recrue
		global_data.nodeGroupList[id]=instance
	else:
		pass
	container.add_child(instance)
	instance._update_style()

func remove_char_card(id: int) -> void:
	if(!id==0):
		var instance: Node = global_data.nodeNpcList[id]
		container_npc.remove_child(instance)
		instance.queue_free()
