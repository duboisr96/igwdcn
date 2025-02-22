shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform vec4 outline_color : source_color;
uniform float outline_width = 2.0;

void fragment() {
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	float lum_center = dot(pixelatedtext.rgb, vec3(0.299, 0.587, 0.114)); // Luminance of current pixel

	ALBEDO = pixelatedtext.rgb;
	
	for(int y = -1 * int(outline_width); y <= int(outline_width); y++)
	for(int x = -1 * int(outline_width); x <= int(outline_width); x++)
	{
		vec2 sample_uv = SCREEN_UV + vec2(float(x), float(y)) * pixel_size;
		vec4 tex = texture(SCREEN_TEXTURE, sample_uv);
		float lum_sample = dot(tex.rgb, vec3(0.299, 0.587, 0.114));

		// If luminance difference is significant, draw an outline
		if(abs(lum_center - lum_sample) > 0.1) {
			ALBEDO = outline_color.rgb;
			ALPHA = 1.0;
		}
	}
}