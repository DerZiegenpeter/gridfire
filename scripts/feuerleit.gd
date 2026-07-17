extends Node2D
class_name Feuerleit

@export var symbol_size: float = 32.0
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

	var frame := Color(0.05, 0.1, 0.2, 0.95)
	var fill := Color(0.1, 0.18, 0.35, 0.9)
	var accent := Color(0.4, 0.75, 1.0, 1.0)

	# Abgerundetes Rechteck (C2 / Leitstelle)
	var rect := Rect2(-half, -half * 0.85, s, s * 0.85)
	draw_rect(rect, fill, true)
	draw_rect(rect, frame, false, 2.6)

	# Antenna / Funk Symbol
	draw_line(Vector2(0, -half * 0.5), Vector2(0, -half * 1.15), accent, 2.2, true)
	draw_circle(Vector2(0, -half * 1.2), 3.5, accent)

	# Kleines Raster (Feuerleit)
	var r := s * 0.18
	draw_line(Vector2(-r, -r * 0.3), Vector2(r, -r * 0.3), accent, 1.6, true)
	draw_line(Vector2(-r, r * 0.3), Vector2(r, r * 0.3), accent, 1.6, true)
	draw_line(Vector2(-r * 0.3, -r), Vector2(-r * 0.3, r), accent, 1.6, true)
	draw_line(Vector2(r * 0.3, -r), Vector2(r * 0.3, r), accent, 1.6, true)

	# Label
	var font := ThemeDB.fallback_font
	var font_size := 14
	var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 14)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.03, 0.06, 0.12, 0.8), true)
	draw_string(font, text_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.5, 0.85, 1.0))
