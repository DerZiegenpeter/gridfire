@tool
extends Node2D
class_name TerrainGenerator

@export var map_size: Vector2i = Vector2i(2048, 2048)
@export var noise_seed: int = 1337
@export var frequency: float = 0.0035
@export var octaves: int = 5
@export var lacunarity: float = 2.0
@export var gain: float = 0.55

@export var min_height_m: float = 80.0
@export var max_height_m: float = 420.0

var noise: FastNoiseLite

var terrain_texture: ImageTexture

func _ready() -> void:
    if not Engine.is_editor_hint():
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

    for y in map_size.y:
        for x in map_size.x:
            var noise_value: float = noise.get_noise_2d(x, y)
            var h: float = noise_value * 0.5 + 0.5

            var color: Color
            if h < 0.3:
                color = Color(0.05, 0.08, 0.05)      # very dark (valleys)
            elif h < 0.5:
                color = Color(0.12, 0.22, 0.10)
            elif h < 0.7:
                color = Color(0.25, 0.32, 0.18)
            else:
                color = Color(0.35, 0.38, 0.25)      # brighter hills

            img.set_pixel(x, y, color)

    terrain_texture = ImageTexture.create_from_image(img)
    var sprite := get_node_or_null("TerrainSprite") as Sprite2D
    if sprite:
        sprite.texture = terrain_texture
        sprite.position = map_size / 2.0
        sprite.centered = false

func get_height_meters(world_pos: Vector2) -> float:
    if not noise:
        return 0.0
    var noise_value: float = noise.get_noise_2d(world_pos.x, world_pos.y)
    var h: float = noise_value * 0.5 + 0.5
    return lerp(min_height_m, max_height_m, h)