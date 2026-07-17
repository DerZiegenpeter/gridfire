extends Node2D
class_name Haubitze

@export var symbol_size: float = 28.0
@export var label_text: String = "Haubitze"
@export var zug_nummer: int = 1

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

	var frame := Color(0.15, 0.08, 0.02, 0.95)
	var fill := Color(0.28, 0.16, 0.05, 0.9)
	var accent := Color(1.0, 0.7, 0.2, 1.0)

	# NATO Artillery Symbol (Kreis)
	draw_circle(Vector2.ZERO, half, fill)
	draw_arc(Vector2.ZERO, half, 0, TAU, 32, frame, 2.8, true)

	# Innerer Punkt + Kreuz (Haubitze)
	draw_circle(Vector2.ZERO, s * 0.12, accent)
	var arm := s * 0.28
	draw_line(Vector2(-arm, 0), Vector2(arm, 0), accent, 2.0, true)
	draw_line(Vector2(0, -arm), Vector2(0, arm), accent, 2.0, true)

	# Label
	var text := "%s %d" % [label_text, zug_nummer]
	var font := ThemeDB.fallback_font
	var font_size := 13
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 15)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.1, 0.05, 0.02, 0.8), true)
	draw_string(font, text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(1.0, 0.8, 0.35))
