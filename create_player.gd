extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/invalidName.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_validate_pressed() -> void:
	var newName = $MarginContainer/VBoxContainer/NameInput.get_text()
	
	if newName.length() > 1:
		global_data.modifyPlayerName(newName)
		EventBus.emit_signal("deleteMeDaddy")
	else:
		$MarginContainer/VBoxContainer/invalidName.visible = true
