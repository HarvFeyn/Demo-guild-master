extends Node

var nextIdChar: int = 0
var statNpcList: Dictionary[int, CharStats] = {}
var nodeNpcList: Dictionary[int, Node] = {}
var nodeGroupList: Dictionary[int, Node] = {}
var selectedTeam: Dictionary[int, int] = {}
enum Screen { TEAM_MANAGER,DUNGEON,CREATE_PLAYER }
var current_screen: Screen

func gainXpSelected(Xp:int) -> void:
	for char: int in selectedTeam:
		statNpcList[char].experience = statNpcList[char].experience + Xp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func resetData() -> void:
	statNpcList = {}
	selectedTeam = {}
	nodeNpcList = {}
	global_data.statNpcList[0] = null
