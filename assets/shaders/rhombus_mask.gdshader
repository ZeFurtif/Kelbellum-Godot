shader_type canvas_item;

uniform float offset : hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
	float cutoff_left = offset * abs(1.0-UV.y);
	float cutoff_right = 1.0-(UV.y*offset);
	float alpha = 1.0;
	if (UV.x < cutoff_left || UV.x > cutoff_right) {
		alpha = 0.0;
	}
	COLOR = vec4(0.8,0.8,0.8, alpha);
}
