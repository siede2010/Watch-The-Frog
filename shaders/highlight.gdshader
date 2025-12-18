shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0.0, 10.0, 1) = 1.0;
uniform int shadow_y : hint_range(0,4,1) = 0;

const vec2[] offsets = {
	vec2(1,0), vec2(-1,0), vec2(0,1), vec2(0,-1)
};

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0;
	
	for (int off = 0; off <= shadow_y; off++) {
		for (int i = 0; i < offsets.length(); i++) {
			vec2 shadowOffset = vec2(offsets[i].x,offsets[i].y - float(off));
			outline += texture(TEXTURE,UV + size * shadowOffset).a;
		}
	}
	outline = min(outline,1.0);
	
	vec4 color = texture(TEXTURE,UV);
	COLOR = mix(color, line_color, outline - color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
