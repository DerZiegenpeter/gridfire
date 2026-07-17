extends Node2D
class_name BStelle

## Beobachtungsstelle – NATO-Stil: Dreieck (Observation Post)

@export var symbol_size: float = 32.0
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

	# Farben (Freundkräfte – dunkles Oliv mit gelbem Akzent)
	var frame_col := Color(0.08, 0.15, 0.06, 0.98)
	var fill_col  := Color(0.18, 0.32, 0.12, 0.92)
	var accent    := Color(0.95, 0.9, 0.2, 1.0)

	# === Gleichseitiges Dreieck (Spitze nach oben) ===
	var p1 := Vector2(0, -half * 1.05)          # Spitze
	var p2 := Vector2(-half * 0.95, half * 0.75) # links unten
	var p3 := Vector2( half * 0.95, half * 0.75) # rechts unten

	var points := PackedVector2Array([p1, p2, p3])

	# Füllung + Umriss
	draw_colored_polygon(points, fill_col)
	draw_polyline(PackedVector2Array([p1, p2, p3, p1]), frame_col, 2.8, true)

	# Kleines Beobachtungs-Auge in der Mitte
	draw_circle(Vector2(0, half * 0.05), s * 0.11, accent)
	draw_circle(Vector2(0, half * 0.05), s * 0.055, frame_col)

	# Label
	var font := ThemeDB.fallback_font
	var font_size := 14
	var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var text_pos := Vector2(-text_size.x * 0.5, half + 18)
	var bg := Rect2(text_pos.x - 4, text_pos.y - font_size + 1, text_size.x + 8, font_size + 4)
	draw_rect(bg, Color(0.04, 0.08, 0.03, 0.82), true)
	draw_string(font, text_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color(0.92, 0.95, 0.35))

func get_observer_position() -> Vector2:
	return global_position
