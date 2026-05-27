extends Resource
class_name CharStats

enum BuffableStats {
	MAX_HEALTH,
	DEFENSE,
	POWER,
}

enum EnumCharClass {
	TANK,
	DPS,
	HEALER,
}

const STAT_CURVES: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://cpcb2nprbfnjs"),
	BuffableStats.DEFENSE: preload("uid://bin1ihhywc17j"),
	BuffableStats.POWER: preload("uid://cndswoq0w30eo"),
}

const BASE_LEVEL_XP: float = 100.0

signal health_depleted
signal health_changed(current_health: int, max_health: int)

var base_max_health: int = 100
var base_defense: int = 15
var base_power: int = 35
var experience: int = 0: set = _on_experience_set
var charClass: EnumCharClass
var charName: String = ""
var idChar: int
var level: int:
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_XP) + 0.5))
var current_max_health: int = 100
var current_defense: int = 10
var current_power: int = 10

var health: int = 0

func _init(newCharName: String, newCharClass: EnumCharClass) -> void:
	idChar = global_data.nextIdChar
	global_data.nextIdChar += 1
	charName = newCharName
	charClass = newCharClass
	setup_stats.call_deferred()
	recalculate_stats()
	
func setup_stats() -> void:
	health = current_max_health

func recalculate_stats() -> void:
	var stat_sample_pos: float = ( float(level) / 100.0 ) + 0.01
	if(charClass==EnumCharClass.TANK):
		current_max_health = (base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos))*2
		current_power = base_power/2 * STAT_CURVES[BuffableStats.POWER].sample(stat_sample_pos)
		current_defense = base_defense * 2 * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)
	elif(charClass==EnumCharClass.DPS):
		current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
		current_power = base_power * STAT_CURVES[BuffableStats.POWER].sample(stat_sample_pos)
		current_defense = base_defense/1.5 * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)
	else:
		current_max_health = base_max_health * STAT_CURVES[BuffableStats.MAX_HEALTH].sample(stat_sample_pos)
		current_power = base_power * STAT_CURVES[BuffableStats.POWER].sample(stat_sample_pos)
		current_defense = base_defense * STAT_CURVES[BuffableStats.DEFENSE].sample(stat_sample_pos)



func _on_health_set(new_value: int) -> void:
	health = clampi(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()

func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value
	if not old_level == level:
		recalculate_stats()

func get_display_name() -> String:
	return "%s - %s - lvl %d" % [charName, EnumCharClass.keys()[charClass], level]
