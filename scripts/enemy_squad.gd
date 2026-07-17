extends Node2D
class_name EnemySquad

## Schützengruppe (~12 Mann) mit NATO-Infanterie-Symbol
## Bei starkem Zoom: einzelne rote Punkte

enum State { ADVANCING, FAN_OUT, SECURITY_360 }

@export var squad_size: int = 12
@export var move_speed: float = 18.0          # Pixel pro Sekunde
@export var symbol_size: float = 26.0
@export var zoom_threshold: float = 1.6       # ab diesem Zoom Einzelpunkte zeigen

var state: State = State.ADVANCING
var target_pos: Vector2 = Vector2.ZERO
var attack_dir: Vector2 = Vector2(0, 1)       # Richtung in die sie laufen
var soldiers: Array[Vector2] = []             # relative Positionen der einzelnen Schützen
var formation_timer: float = 0.0
var has_reached_objective := false

func _ready() -> void:
	_init_soldiers()
	z_index = 8

func setup(start_pos: Vector2, direction: Vector2, objective: Vector2) -> void:
	position = start_pos
	attack_dir = direction.normalized()
	target_pos = objective
	state = State.ADVANCING
	has_reached_objective = false
	_init_soldiers()
	queue_redraw()

func _init_soldiers() -> void:
	soldiers.clear()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	# Lose Kolonne / Gruppe
	for i in squad_size:
		var ox := rng.randf_range(-14.0, 14.0)
		var oy := rng.randf_range(-10.0, 10.0)
		soldiers.append(Vector2(ox, oy))

func _process(delta: float) -> void:
	if get_tree().paused:
		return

	match state:
		State.ADVANCING:
			_advance(delta)
		State.FAN_OUT:
			_fan_out(delta)
		State.SECURITY_360:
			_security_360(delta)

	queue_redraw()

func _advance(delta: float) -> void:
	var to_target := target_pos - position
	if to_target.length() < 40.0:
		_decide_next_state()
		return
	position += attack_dir * move_speed * delta

func _decide_next_state() -> void:
	has_reached_objective = true
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf() > 0.45:
		state = State.FAN_OUT
		_start_fan_out()
	else:
		state = State.SECURITY_360
		_start_360()

func _start_fan_out() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in soldiers.size():
		var angle := rng.randf_range(-PI * 0.6, PI * 0.6)
		var dist := rng.randf_range(18.0, 55.0)
		soldiers[i] = Vector2(cos(angle), sin(angle)) * dist

func _fan_out(delta: float) -> void:
	# Soldaten bewegen sich langsam in ihre Fan-Out Positionen (schon gesetzt)
	pass

func _start_360() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in soldiers.size():
		var angle := (TAU / squad_size) * i + rng.randf_range(-0.15, 0.15)
		var dist := rng.randf_range(22.0, 38.0)
		soldiers[i] = Vector2(cos(angle), sin(angle)) * dist

func _security_360(delta: float) -> void:
	# Bleiben in der Kreisformation
	pass

func _draw() -> void:
	var cam := get_viewport().get_camera_2d()
	var zoom_x: float = cam.zoom.x if cam else 1.0

	if zoom_x >= zoom_threshold:
		_draw_soldiers()
	else:
		_draw_nato_symbol()

func _draw_nato_symbol() -> void:
	var s := symbol_size
	var half := s * 0.5

	# Feind = Rot
	var frame := Color(0.55, 0.05, 0.05, 0.95)
	var fill  := Color(0.45, 0.08, 0.08, 0.88)
	var accent := Color(1.0, 0.35, 0.3, 1.0)

	# Rechteck (Infanterie)
	var rect := Rect2(-half, -half * 0.75, s, s * 0.75)
	draw_rect(rect, fill, true)
	draw_rect(rect, frame, false, 2.4)

	# Klassisches NATO "X" (Infanterie)
	var m := s * 0.28
	draw_line(Vector2(-m, -m * 0.7), Vector2(m, m * 0.7), accent, 2.3, true)
	draw_line(Vector2(m, -m * 0.7), Vector2(-m, m * 0.7), accent, 2.3, true)

	# Kleiner Squad-Indikator (Punkt)
	draw_circle(Vector2(0, half * 0.95), 3.2, accent)

func _draw_soldiers() -> void:
	for offset in soldiers:
		var p := offset
		# Roter Punkt = einzelner Schütze
		draw_circle(p, 3.2, Color(0.9, 0.15, 0.1, 0.95))
		draw_circle(p, 1.6, Color(1.0, 0.4, 0.3, 1.0))
