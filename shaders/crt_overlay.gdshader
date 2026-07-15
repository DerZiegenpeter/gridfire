shader_type canvas_item;

uniform float scanline_count : hint_range(50.0, 800.0) = 180.0;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.25;
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.8;

void fragment() {
    vec2 uv = UV;
    vec4 color = COLOR;

    float scan = sin(uv.y * scanline_count * 3.14159) * 0.5 + 0.5;
    color.rgb *= mix(1.0, scan * 0.7 + 0.3, scanline_intensity);

    vec2 center = uv - 0.5;
    float dist = dot(center, center);
    float vignette = 1.0 - dist * vignette_strength;
    color.rgb *= clamp(vignette, 0.3, 1.0);

    COLOR = color;
}