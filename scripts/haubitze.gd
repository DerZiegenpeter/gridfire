extends Node2D
class_name Haubitze

## Haubitzenzug – klassisches NATO Field Artillery Symbol (Kreis + Mittelpunkt)

@export var symbol_size: float = 30.0
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

	var frame := Color(0.12, 0.07, 0.02, 0.98)
	var fill  := Color(0.32, 0.18, 0.06, 0.92)
	var accent := Color(1.0, 0.72, 0.18, 1.0)

	# Äußerer Kreis (NATO Artillery)
	draw_circle(Vector2.ZERO, half, fill)
	draw_arc(Vector2.ZERO, half, 0.0, TAU, 36, frame, 2.7, true)

	# Klassischer Mittelpunkt (Field Artillery)
	draw_circle(Vector2.ZERO, s * 0.16, accent)
	draw_circle(Vector2.ZERO, s * 0.07, frame)

	# Label
	var text := "%s %d" % [label_text, zug_nummer]
	var font := ThemeDB.fallback_font
	var font_size := 13
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 16)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.1, 0.05, 0.02, 0.82), true)
	draw_string(font, text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(1.0, 0.82, 0.35))
