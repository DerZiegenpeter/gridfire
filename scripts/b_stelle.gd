extends Node2D
class_name BStelle

## Beobachtungsstelle (Forward Observer / Observation Post)
## NATO APP-6 style symbol

@export var map_size: Vector2i = Vector2i(2000, 2000)
@export var symbol_size: float = 28.0
@export var label_text: String = "B-Stelle"

var is_placed := false

func _ready() -> void:
	# Zufällige Position mit Abstand zum Rand
	var margin := 180.0
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	position = Vector2(
		rng.randf_range(margin, map_size.x - margin),
		rng.randf_range(margin, map_size.y - margin)
	)
	is_placed = true
	queue_redraw()
	z_index = 10

func _draw() -> void:
	if not is_placed:
		return

	var s := symbol_size
	var half := s * 0.5

	# === NATO Observation Post Symbol ===
	# Äußerer Rahmen (Freund = blau nach APP-6, wir nehmen dunkles Oliv/Schwarz für Karte)
	var frame_col := Color(0.05, 0.12, 0.05, 0.95)
	var fill_col := Color(0.15, 0.28, 0.12, 0.85)
	var accent := Color(0.9, 0.95, 0.3, 1.0)  # gelb für Sichtbarkeit

	# Gefülltes Quadrat (leicht abgerundet wirkend durch dicke Linie)
	var rect := Rect2(-half, -half, s, s)
	draw_rect(rect, fill_col, true)
	draw_rect(rect, frame_col, false, 3.0)

	# Inneres Kreuz / Beobachtungs-Symbol
	var cross_len := s * 0.32
	draw_line(Vector2(-cross_len, 0), Vector2(cross_len, 0), accent, 2.5, true)
	draw_line(Vector2(0, -cross_len), Vector2(0, cross_len), accent, 2.5, true)

	# Kleiner Kreis in der Mitte (Auge / Beobachtung)
	draw_circle(Vector2.ZERO, s * 0.13, accent)
	draw_circle(Vector2.ZERO, s * 0.07, frame_col)

	# Label unter dem Symbol
	var font := ThemeDB.fallback_font
	var font_size := 15
	var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 18)

	# Hintergrund für bessere Lesbarkeit
	var bg_rect := Rect2(text_pos.x - 4, text_pos.y - font_size + 2, text_size.x + 8, font_size + 4)
	draw_rect(bg_rect, Color(0.05, 0.1, 0.05, 0.75), true)
	draw_string(font, text_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.85, 0.95, 0.4))

func get_observer_position() -> Vector2:
	return global_position
