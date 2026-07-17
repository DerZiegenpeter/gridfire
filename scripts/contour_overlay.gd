extends Sprite2D
class_name ContourOverlay

@export var map_size: Vector2i = Vector2i(2000, 2000)
@export var terrain_path: NodePath = NodePath("../TerrainSprite")

@export var contour_interval: float = 25.0
@export var index_interval: float = 100.0
@export var sample_step: int = 10

@export var normal_color: Color = Color(0.10, 0.20, 0.08, 0.70)
@export var index_color: Color = Color(0.06, 0.13, 0.05, 0.95)

var terrain: TerrainGenerator

func _ready() -> void:
	if terrain_path:
		terrain = get_node_or_null(terrain_path) as TerrainGenerator
	
	# Warten bis Terrain fertig ist
	await get_tree().process_frame
	await get_tree().process_frame
	
	_bake_contours()

func _bake_contours() -> void:
	if not terrain or terrain.heights.is_empty():
		return

	var w: int = map_size.x
	var h: int = map_size.y
	
	# Transparentes Bild für die Linien
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))

	var min_h: float = terrain.min_height_m
	var max_h: float = terrain.max_height_m

	var levels: Array[float] = []
	var level: float = ceilf(min_h / contour_interval) * contour_interval
	while level <= max_h:
		levels.append(level)
		level += contour_interval

	for lvl in levels:
		var is_idx: bool = (int(round(lvl)) % int(index_interval) == 0)
		var col: Color = index_color if is_idx else normal_color
		_rasterize_isolines(img, lvl, col, is_idx)

	var tex := ImageTexture.create_from_image(img)
	self.texture = tex
	self.position = Vector2.ZERO
	self.centered = false
	self.z_index = 1   # über dem Terrain

func _rasterize_isolines(img: Image, level: float, col: Color, is_idx: bool) -> void:
	var step: int = sample_step
	var w: int = map_size.x
	var h: int = map_size.y
	var thickness: int = 2 if is_idx else 1

	for y in range(0, h - step, step):
		for x in range(0, w - step, step):
			var h00: float = terrain.get_height_meters(Vector2(x, y))
			var h10: float = terrain.get_height_meters(Vector2(x + step, y))
			var h01: float = terrain.get_height_meters(Vector2(x, y + step))
			var h11: float = terrain.get_height_meters(Vector2(x + step, y + step))

			var points: Array[Vector2] = []
			_check_edge(Vector2(x, y), h00, Vector2(x + step, y), h10, level, points)
			_check_edge(Vector2(x + step, y), h10, Vector2(x + step, y + step), h11, level, points)
			_check_edge(Vector2(x + step, y + step), h11, Vector2(x, y + step), h01, level, points)
			_check_edge(Vector2(x, y + step), h01, Vector2(x, y), h00, level, points)

			if points.size() >= 2:
				_draw_line_on_image(img, points[0], points[1], col, thickness)

func _check_edge(p1: Vector2, h1: float, p2: Vector2, h2: float, level: float, points: Array[Vector2]) -> void:
	if (h1 < level and h2 >= level) or (h1 >= level and h2 < level):
		var t: float = (level - h1) / (h2 - h1 + 0.00001)
		points.append(p1.lerp(p2, clamp(t, 0.0, 1.0)))

func _draw_line_on_image(img: Image, from: Vector2, to: Vector2, col: Color, thickness: int) -> void:
	var x0: int = int(from.x)
	var y0: int = int(from.y)
	var x1: int = int(to.x)
	var y1: int = int(to.y)

	var dx: int = absi(x1 - x0)
	var dy: int = -absi(y1 - y0)
	var sx: int = 1 if x0 < x1 else -1
	var sy: int = 1 if y0 < y1 else -1
	var err: int = dx + dy

	while true:
		_set_thick_pixel(img, x0, y0, col, thickness)
		if x0 == x1 and y0 == y1:
			break
		var e2: int = 2 * err
		if e2 >= dy:
			err += dy
			x0 += sx
		if e2 <= dx:
			err += dx
			y0 += sy

func _set_thick_pixel(img: Image, x: int, y: int, col: Color, thickness: int) -> void:
	var w: int = img.get_width()
	var h: int = img.get_height()
	for oy in range(-thickness + 1, thickness):
		for ox in range(-thickness + 1, thickness):
			var px: int = x + ox
			var py: int = y + oy
			if px >= 0 and px < w and py >= 0 and py < h:
				img.set_pixel(px, py, col)
