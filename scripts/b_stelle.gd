extends Node2D
class_name BStelle

@export var symbol_size: float = 30.0
@export var label_text: String = "B-Stelle"

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

	var frame_col := Color(0.05, 0.12, 0.05, 0.95)
	var fill_col := Color(0.12, 0.25, 0.10, 0.90)
	var accent := Color(0.95, 0.92, 0.25, 1.0)

	# Quadrat
	var rect := Rect2(-half, -half, s, s)
	draw_rect(rect, fill_col, true)
	draw_rect(rect, frame_col, false, 2.8)

	# Kreuz + Auge
	var cross := s * 0.30
	draw_line(Vector2(-cross, 0), Vector2(cross, 0), accent, 2.4, true)
	draw_line(Vector2(0, -cross), Vector2(0, cross), accent, 2.4, true)
	draw_circle(Vector2.ZERO, s * 0.12, accent)
	draw_circle(Vector2.ZERO, s * 0.06, frame_col)

	# Label
	var font := ThemeDB.fallback_font
	var font_size := 14
	var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 16)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.04, 0.08, 0.04, 0.8), true)
	draw_string(font, text_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.9, 0.95, 0.4))

func get_observer_position() -> Vector2:
	return global_position
