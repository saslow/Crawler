shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float blur: hint_range(0.0, 5) = 0.35;
uniform float alpha: hint_range(0.0, 1.0, 0.05) = 0.5;

void fragment(){
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);
	COLOR.rgb = color.rgb;
	COLOR.a = color.a * alpha;
}