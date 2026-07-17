extends Node
class_name MissionController

## Steuert Briefing + logische Platzierung aller eigenen Kräfte

enum AttackDir { NORD, OST, SUED, WEST }

@export var map_size: Vector2i = Vector2i(2000, 2000)

var enemy_direction: AttackDir = AttackDir.SUED
var b_stelle: Node2D
var feuerleit: Node2D
var haubitzen: Array[Node2D] = []

func _ready() -> void:
	await get_tree().process_frame
	_setup_mission()

func _setup_mission() -> void:
	# Aktuell fest SÜD (kann später randomisiert werden)
	enemy_direction = AttackDir.SUED

	_place_forces()
	_show_briefing()

func _place_forces() -> void:
	var w := float(map_size.x)
	var h := float(map_size.y)

	# WICHTIG:
	# "Hauptangriffsrichtung SÜD" bedeutet: Der Feind greift nach SÜDEN an.
	# Er kommt also aus dem NORDEN.
	# Eigene Kräfte müssen deshalb im SÜDEN der Karte stehen.
	match enemy_direction:
		AttackDir.SUED:
			# Feind kommt aus Norden → eigene Kräfte im Süden
			# B-Stelle weiter vorne (näher am Feind), Feuerleit + Haubitzen tiefer
			_set_unit_pos("BStelle",   Vector2(w * 0.50, h * 0.62))
			_set_unit_pos("Feuerleit", Vector2(w * 0.42, h * 0.78))
			_set_unit_pos("Haubitze1", Vector2(w * 0.58, h * 0.82))
			_set_unit_pos("Haubitze2", Vector2(w * 0.68, h * 0.75))

		AttackDir.NORD:
			# Feind kommt aus Süden → eigene Kräfte im Norden
			_set_unit_pos("BStelle",   Vector2(w * 0.50, h * 0.38))
			_set_unit_pos("Feuerleit", Vector2(w * 0.42, h * 0.22))
			_set_unit_pos("Haubitze1", Vector2(w * 0.58, h * 0.18))
			_set_unit_pos("Haubitze2", Vector2(w * 0.68, h * 0.25))

		AttackDir.OST:
			# Feind kommt aus Westen → eigene Kräfte im Osten
			_set_unit_pos("BStelle",   Vector2(w * 0.62, h * 0.50))
			_set_unit_pos("Feuerleit", Vector2(w * 0.78, h * 0.42))
			_set_unit_pos("Haubitze1", Vector2(w * 0.82, h * 0.58))
			_set_unit_pos("Haubitze2", Vector2(w * 0.75, h * 0.68))

		AttackDir.WEST:
			# Feind kommt aus Osten → eigene Kräfte im Westen
			_set_unit_pos("BStelle",   Vector2(w * 0.38, h * 0.50))
			_set_unit_pos("Feuerleit", Vector2(w * 0.22, h * 0.42))
			_set_unit_pos("Haubitze1", Vector2(w * 0.18, h * 0.58))
			_set_unit_pos("Haubitze2", Vector2(w * 0.25, h * 0.68))

func _set_unit_pos(node_name: String, pos: Vector2) -> void:
	var node := get_node_or_null("../World/" + node_name)
	if node:
		node.position = pos
		if node.has_method("set_placed"):
			node.set_placed()

func _show_briefing() -> void:
	var briefing := get_node_or_null("../HUD/BriefingPanel")
	if briefing and briefing.has_method("show_briefing"):
		var dir_text := _dir_to_text(enemy_direction)
		briefing.show_briefing(dir_text)

func _dir_to_text(dir: AttackDir) -> String:
	match dir:
		AttackDir.NORD: return "NORD"
		AttackDir.OST:  return "OST"
		AttackDir.SUED: return "SÜD"
		AttackDir.WEST: return "WEST"
	return "UNBEKANNT"

func get_enemy_direction() -> AttackDir:
	return enemy_direction
