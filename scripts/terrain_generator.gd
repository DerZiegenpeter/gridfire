@tool
extends Sprite2D
class_name TerrainGenerator

@export var map_size: Vector2i = Vector2i(2000, 2000)
@export var noise_seed: int = 1337
@export var frequency: float = 0.0018
@export var octaves: int = 4
@export var lacunarity: float = 2.1
@export var gain: float = 0.42

@export var min_height_m: float = 110.0
@export var max_height_m: float = 360.0

var noise: FastNoiseLite

var terrain_texture: ImageTexture

func _ready() -> void:
	generate_terrain()

func generate_terrain() -> void:
	noise = FastNoiseLite.new()
	noise.seed = noise_seed
	noise.frequency = frequency
	noise.fractal_octaves = octaves
	noise.fractal_lacunarity = lacunarity
	noise.fractal_gain = gain
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH

	var img := Image.create(map_size.x, map_size.y, false, Image.FORMAT_RGB8)

	# Sehr dezente, helle Grundfarbe (damit die Höhenlinien klar stehen)
	var col_low  := Color(0.78, 0.86, 0.72)   # helles, weiches Grün
	var col_mid  := Color(0.72, 0.82, 0.65)
	var col_high := Color(0.68, 0.78, 0.58)

	for y in map_size.y:
		for x in map_size.x:
			var noise_value: float = noise.get_noise_2d(x, y)
			var h: float = noise_value * 0.5 + 0.5

			var color: Color
			if h < 0.5:
				color = col_low.lerp(col_mid, h * 2.0)
			else:
				color = col_mid.lerp(col_high, (h - 0.5) * 2.0)

			img.set_pixel(x, y, color)

	terrain_texture = ImageTexture.create_from_image(img)

	self.texture = terrain_texture
	self.position = Vector2.ZERO
	self.centered = false

func get_height_meters(world_pos: Vector2) -> float:
	if not noise:
		return 0.0
	var noise_value: float = noise.get_noise_2d(world_pos.x, world_pos.y)
	var h: float = noise_value * 0.5 + 0.5
	return lerp(min_height_m, max_height_m, h)
