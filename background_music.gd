extends Node

var theme_music = preload("res://assets/sounds/alex-morgan-bebop-coffee-shop-517090.mp3")
var player = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var theme_music = preload("res://assets/sounds/alex-morgan-bebop-coffee-shop-517090.mp3")
	add_child(player)
	player.volume_db = -30
	player.bus = "music"
	player.stream = theme_music
	player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
