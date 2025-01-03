shader_type canvas_item;

uniform vec4 original_0 = vec4(1, 0.8, 0, 1);
uniform vec4 original_1 = vec4(0.8, 1, 0, 1);
uniform vec4 original_2 = vec4(0.8, 1, 0, 1);
uniform vec4 original_3 = vec4(0.8, 1, 0, 1);
uniform vec4 original_4 = vec4(0.8, 1, 0, 1);
uniform vec4 original_5 = vec4(0.8, 1, 0, 1);

uniform vec4 replace_0 = vec4(1, 0, 0, 1);
uniform vec4 replace_1 = vec4(1, 0, 0, 1);
uniform vec4 replace_2 = vec4(1, 0, 0, 1);
uniform vec4 replace_3 = vec4(1, 0, 0, 1);
uniform vec4 replace_4 = vec4(1, 0, 0, 1);
uniform vec4 replace_5 = vec4(1, 0, 0, 1);

const float precision = 0.3;

void fragment() {
	vec3 c = texture(TEXTURE, UV).rgb;

	if ( (c.r >= original_0.r - precision && c.r <= original_0.r + precision) && (c.b >= original_0.b - precision && c.b <= original_0.b + precision) && (c.g >= original_0.g - precision && c.g <= original_0.g + precision)  ) {
		c = replace_0.rgb;
	}

	COLOR.rgb = c;
}