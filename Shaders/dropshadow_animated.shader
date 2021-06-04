shader_type canvas_item;
render_mode blend_mix;

uniform vec4 region;
uniform  vec2 offset;
uniform vec4 modulate : hint_color;

void vertex() {
	// VERTEX.y = VERTEX.y * (1.0 + newOffset.y);
}
void fragment() {
	COLOR = texture(TEXTURE, UV);
	// COLOR = mix(shadow, col, col.a);
}
