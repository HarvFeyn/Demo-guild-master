extends Control

var createPlayer: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	createPlayer = add_child_to_current_scene("res://create_player.tscn")
	EventBus.deleteMeDaddy.connect(remove_create_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_child_to_current_scene(filepath: String) -> Node:
	var packed_scene: PackedScene = load(filepath)
	var instance: Node = packed_scene.instantiate()
	get_tree().current_scene.add_child(instance)
	return instance

func remove_create_player() -> void:
	get_tree().current_scene.remove_child(createPlayer)

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
