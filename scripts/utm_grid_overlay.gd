extends Node2D

@export var map_size: Vector2i = Vector2i(2048, 2048)
@export var meters_per_pixel: float = 5.0
@export var major_grid_meters: int = 1000
@export var minor_grid_meters: int = 200
@export var contour_step_meters: int = 50

@export var utm_easting_base: float = 512000.0
@export var utm_northing_base: float = 5480000.0
@export var utm_zone: String = "32U"

@export var terrain_generator_path: NodePath

var terrain_generator: TerrainGenerator

var label_font: Font

func _ready() -> void:
    label_font = ThemeDB.fallback_font
    if terrain_generator_path:
        terrain_generator = get_node(terrain_generator_path) as TerrainGenerator

func _draw() -> void:
    var major_px := int(major_grid_meters / meters_per_pixel)
    var minor_px := int(minor_grid_meters / meters_per_pixel)

    # Minor Grid Lines (thin)
    for x in range(0, map_size.x + 1, minor_px):
        var is_major := (x % major_px) == 0
        if not is_major:
            draw_line(Vector2(x, 0), Vector2(x, map_size.y), Color(0.0, 0.6, 0.3, 0.35), 1.0)

    for y in range(0, map_size.y + 1, minor_px):
        var is_major := (y % major_px) == 0
        if not is_major:
            draw_line(Vector2(0, y), Vector2(map_size.x, y), Color(0.0, 0.6, 0.3, 0.35), 1.0)

    # Major Grid Lines (thick + bright)
    for x in range(0, map_size.x + 1, major_px):
        draw_line(Vector2(x, 0), Vector2(x, map_size.y), Color(0.0, 1.0, 0.5, 0.9), 2.5)
        if x > 0:
            var east := int(utm_easting_base + x * meters_per_pixel)
            draw_string(label_font, Vector2(x + 6, 18), str(east / 1000), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.3, 1.0, 0.6))

    for y in range(0, map_size.y + 1, major_px):
        draw_line(Vector2(0, y), Vector2(map_size.x, y), Color(0.0, 1.0, 0.5, 0.9), 2.5)
        if y > 0:
            var north := int(utm_northing_base + (map_size.y - y) * meters_per_pixel)
            draw_string(label_font, Vector2(6, y + 14), str(north / 1000), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(0.3, 1.0, 0.6))

    # Simple Contour Lines (Höhenlinien)
    if terrain_generator:
        var contour_step_px := int(contour_step_meters / meters_per_pixel)
        for x in range(0, map_size.x, contour_step_px):
            for y in range(0, map_size.y, contour_step_px):
                var h := terrain_generator.get_height_meters(Vector2(x, y))
                # Draw small markers or lines at height thresholds
                if int(h) % 50 == 0:
                    draw_circle(Vector2(x, y), 1.5, Color(1.0, 0.9, 0.3, 0.6))  # golden contour dots for now

func world_to_utm_string(world_pos: Vector2) -> String:
    var east := int(utm_easting_base + world_pos.x * meters_per_pixel)
    var north := int(utm_northing_base + (map_size.y - world_pos.y) * meters_per_pixel)
    return "%s %06d %07d" % [utm_zone, east, north]