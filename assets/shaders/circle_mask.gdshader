shader_type canvas_item;

uniform float clip : hint_range(0.0, 0.5, 0.01) = 1.0;

void fragment() {
	vec2 cUV = vec2(UV.x - 0.5, UV.y -0.5);
	float hypothenuse = sqrt((cUV.x*cUV.x) + (cUV.y*cUV.y));
	float alpha = 1.0;
	if (hypothenuse > clip) {
		alpha = 0.0;
	}
	COLOR = vec4(texture(TEXTURE,UV).rgb, alpha);
}