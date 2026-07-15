extends Node2D

@export var map_size: Vector2i = Vector2i(2048, 2048)
@export var meters_per_pixel: float = 5.0
@export var major_grid_meters: int = 1000
@export var minor_grid_meters: int = 200

@export var utm_easting_base: float = 512000.0
@export var utm_northing_base: float = 5480000.0
@export var utm_zone: String = "32U"

@export var major_line_color: Color = Color(0.0, 1.0, 0.45, 0.95)
@export var minor_line_color: Color = Color(0.0, 0.85, 0.35, 0.55)
@export var label_color: Color = Color(0.3, 1.0, 0.6)

var label_font: Font

func _ready() -> void:
    label_font = ThemeDB.fallback_font

func _draw() -> void:
    var major_px := int(major_grid_meters / meters_per_pixel)
    var minor_px := int(minor_grid_meters / meters_per_pixel)

    for x in range(0, map_size.x + 1, minor_px):
        var is_major := (x % major_px) == 0
        var color := major_line_color if is_major else minor_line_color
        var width := 2.5 if is_major else 1.0
        draw_line(Vector2(x, 0), Vector2(x, map_size.y), color, width)

        if is_major and x > 0:
            var east := int(utm_easting_base + x * meters_per_pixel)
            var text := "%d" % (east / 1000)
            draw_string(label_font, Vector2(x + 6, 20), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, label_color)

    for y in range(0, map_size.y + 1, minor_px):
        var is_major := (y % major_px) == 0
        var color := major_line_color if is_major else minor_line_color
        var width := 2.5 if is_major else 1.0
        draw_line(Vector2(0, y), Vector2(map_size.x, y), color, width)

        if is_major and y > 0:
            var north := int(utm_northing_base + (map_size.y - y) * meters_per_pixel)
            var text := "%d" % (north / 1000)
            draw_string(label_font, Vector2(6, y + 16), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, label_color)

func world_to_utm_string(world_pos: Vector2) -> String:
    var east := int(utm_easting_base + world_pos.x * meters_per_pixel)
    var north := int(utm_northing_base + (map_size.y - world_pos.y) * meters_per_pixel)
    return "%s %06d %07d" % [utm_zone, east, north]