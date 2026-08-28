shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform float black_threshold = 0.05;

void fragment() {
	vec4 tex = texture(texture_albedo, UV);
	
	// Discard pixels that are nearly black (chroma key)
	float brightness = max(max(tex.r, tex.g), tex.b);
	if (brightness < black_threshold) {
		discard;
	}
	
	ALBEDO = tex.rgb;
	ALPHA = 1.0;
}
