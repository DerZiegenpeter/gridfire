extends Node2D
class_name Feuerleit

## Feuerleitstelle / FDC – Command-style Symbol

@export var symbol_size: float = 34.0
@export var label_text: String = "Feuerleit"

var is_placed := false

func set_placed() -> void:
	is_placed = true
	queue_redraw()
	z_index = 10

func _draw() -> void:
	if not is_placed:
		return

	var s := symbol_size
	var half := s * 0.5

	var frame := Color(0.05, 0.1, 0.22, 0.98)
	var fill  := Color(0.1, 0.18, 0.38, 0.92)
	var accent := Color(0.45, 0.8, 1.0, 1.0)

	# Abgerundetes Rechteck (C2 / Leitstelle)
	var rect := Rect2(-half, -half * 0.82, s, s * 0.82)
	draw_rect(rect, fill, true)
	draw_rect(rect, frame, false, 2.6)

	# Funk / Antenne
	draw_line(Vector2(0, -half * 0.45), Vector2(0, -half * 1.18), accent, 2.3, true)
	draw_circle(Vector2(0, -half * 1.25), 3.8, accent)

	# Kleines Fadenkreuz (Feuerleitung)
	var r := s * 0.17
	draw_line(Vector2(-r, 0), Vector2(r, 0), accent, 1.7, true)
	draw_line(Vector2(0, -r), Vector2(0, r), accent, 1.7, true)
	draw_circle(Vector2.ZERO, r * 0.45, Color(0, 0, 0, 0))
	draw_arc(Vector2.ZERO, r * 0.55, 0.0, TAU, 20, accent, 1.5, true)

	# Label
	var font := ThemeDB.fallback_font
	var font_size := 14
	var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 15)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.03, 0.06, 0.12, 0.82), true)
	draw_string(font, text_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.55, 0.88, 1.0))
