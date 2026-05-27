extends Node

var theme_music: Resource = preload("uid://dmvy6r1hsy8sj")
var player: Node = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(player)
	player.volume_db = -30
	player.bus = "music"
	player.stream = theme_music
	player.stream.loop = true
	player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
