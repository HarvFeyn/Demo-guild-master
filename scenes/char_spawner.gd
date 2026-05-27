extends Node

var container_player: Node
var container_npc: Node

func add_char_card(id: int) -> void:
	var instance: Node = load("uid://cr6ru7nhhudnb").instantiate()
	instance.idChar = id
	var container: Node = container_player if id == 0 else container_npc
	container.add_child(instance)
	global_data.nodeNpcList[id]=instance

func remove_char_card(id: int) -> void:
	if(!id==0):
		var instance: Node = global_data.nodeNpcList[id]
		container_npc.remove_child(instance)
		instance.queue_free()
