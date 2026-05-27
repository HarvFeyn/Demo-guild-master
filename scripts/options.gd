extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_with_sound_pressed() -> void:
	get_tree().change_scene_to_file("uid://b8j4tmq5qo4f0")
