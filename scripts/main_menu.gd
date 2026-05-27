extends MarginContainer

const ConfirmationPopup: Resource = preload("uid://coke752lxlv4o")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("uid://dq3xmi1gg4uo5")


func _on_new_game_pressed() -> void:
	if(global_data.statNpcList.has(0)):
		var popup: Node = ConfirmationPopup.instantiate()
		popup.setup("Commencer une nouvelle partie va supprimer la partie existante")
		add_child(popup)
		popup.confirmed.connect(func()->void: start_new_game())
		popup.cancelled.connect(func()->void: pass)
	else:
		start_new_game()

func start_new_game() -> void:
	global_data.resetData()
	get_tree().change_scene_to_file("uid://fpbswm05qhgk")

func _on_continue_pressed() -> void:
	if(global_data.statNpcList.has(0)):
		get_tree().change_scene_to_file("uid://fpbswm05qhgk")
