extends Node
class_name MissionController

## Briefing + Platzierung eigener Kräfte + Spawn der Feind-Schützengruppen

enum AttackDir { NORD, OST, SUED, WEST }

@export var map_size: Vector2i = Vector2i(2000, 2000)
@export var num_enemy_squads: int = 5

var enemy_direction: AttackDir = AttackDir.SUED
var enemy_squads: Array[Node2D] = []

const EnemySquadScript = preload("res://scripts/enemy_squad.gd")

func _ready() -> void:
	await get_tree().process_frame
	_setup_mission()

func _setup_mission() -> void:
	enemy_direction = AttackDir.SUED

	_place_friendly_forces()
	_spawn_enemy_squads()
	_show_briefing()

func _place_friendly_forces() -> void:
	var w := float(map_size.x)
	var h := float(map_size.y)

	match enemy_direction:
		AttackDir.SUED:
			# Feind kommt aus Norden → eigene im Süden
			_set_unit_pos("BStelle",   Vector2(w * 0.50, h * 0.62))
			_set_unit_pos("Feuerleit", Vector2(w * 0.42, h * 0.78))
			_set_unit_pos("Haubitze1", Vector2(w * 0.58, h * 0.82))
			_set_unit_pos("Haubitze2", Vector2(w * 0.68, h * 0.75))

		AttackDir.NORD:
			_set_unit_pos("BStelle",   Vector2(w * 0.50, h * 0.38))
			_set_unit_pos("Feuerleit", Vector2(w * 0.42, h * 0.22))
			_set_unit_pos("Haubitze1", Vector2(w * 0.58, h * 0.18))
			_set_unit_pos("Haubitze2", Vector2(w * 0.68, h * 0.25))

		AttackDir.OST:
			_set_unit_pos("BStelle",   Vector2(w * 0.62, h * 0.50))
			_set_unit_pos("Feuerleit", Vector2(w * 0.78, h * 0.42))
			_set_unit_pos("Haubitze1", Vector2(w * 0.82, h * 0.58))
			_set_unit_pos("Haubitze2", Vector2(w * 0.75, h * 0.68))

		AttackDir.WEST:
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

func _spawn_enemy_squads() -> void:
	var w := float(map_size.x)
	var h := float(map_size.y)
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var start_y: float
	var target_y: float
	var dir: Vector2

	match enemy_direction:
		AttackDir.SUED:
			# Kommen aus Norden, laufen nach Süden
			start_y = 80.0
			target_y = h * 0.45
			dir = Vector2(0, 1)
		AttackDir.NORD:
			start_y = h - 80.0
			target_y = h * 0.55
			dir = Vector2(0, -1)
		AttackDir.OST:
			start_y = h * 0.5
			target_y = h * 0.5
			dir = Vector2(1, 0)
		AttackDir.WEST:
			start_y = h * 0.5
			target_y = h * 0.5
			dir = Vector2(-1, 0)

	var world := get_node_or_null("../World")
	if world == null:
		return

	for i in num_enemy_squads:
		var squad := Node2D.new()
		squad.set_script(EnemySquadScript)
		world.add_child(squad)

		var start_x := rng.randf_range(w * 0.15, w * 0.85)
		var start_pos: Vector2
		var objective: Vector2

		match enemy_direction:
			AttackDir.SUED, AttackDir.NORD:
				start_pos = Vector2(start_x, start_y)
				objective = Vector2(start_x + rng.randf_range(-120, 120), target_y)
			AttackDir.OST:
				start_pos = Vector2(80.0, rng.randf_range(h * 0.2, h * 0.8))
				objective = Vector2(w * 0.45, start_pos.y + rng.randf_range(-80, 80))
			AttackDir.WEST:
				start_pos = Vector2(w - 80.0, rng.randf_range(h * 0.2, h * 0.8))
				objective = Vector2(w * 0.55, start_pos.y + rng.randf_range(-80, 80))

		if squad.has_method("setup"):
			squad.setup(start_pos, dir, objective)

		enemy_squads.append(squad)

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
