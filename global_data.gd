extends Node

var playerName: String
var playerLvl = 1
var playerXp = 0
var xpToNextLvl = 10

func modifyPlayerName(NewName:String):
	playerName = NewName

func gainXp(Xp:int):
	playerXp += Xp
	if playerXp >= xpToNextLvl:
		playerLvl += 1
		playerXp = playerXp - xpToNextLvl
		xpToNextLvl = playerLvl*10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
