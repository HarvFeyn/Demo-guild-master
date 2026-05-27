extends Node

var selected_list_container: Node
var label_count: Node

func add_name_to_selected_list(id: int) -> void:
	var label: Node = Label.new()
	label.name = str(id)
	label.text = global_data.statNpcList[id].get_display_name()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selected_list_container.add_child(label)

func remove_name_from_selected_list(id: int) -> void:
	if(global_data.selectedTeam.has(id)):
		global_data.selectedTeam.erase(id)
		var label: Node = selected_list_container.get_node_or_null(str(id))
		if(label):
			label.queue_free()
		refresh_team_count()

func toggle_char_selection(id: int) -> void:
	if(global_data.selectedTeam.has(id)):
		global_data.selectedTeam.erase(id)
		var label: Node = selected_list_container.get_node_or_null(str(id))
		if(label):
			label.queue_free()
	else:
		global_data.selectedTeam[id] = id
		add_name_to_selected_list(id)
	refresh_team_count()
	
func refresh_selected_list() -> void:
	for id: int in global_data.selectedTeam:
		var label: Node = selected_list_container.get_node_or_null(str(id))
		if(label):
			label.free()
		add_name_to_selected_list(id)
	refresh_team_count()

func refresh_team_count() -> void:
	label_count.text = "( %d / 5 ) Joueurs" % global_data.selectedTeam.size()
