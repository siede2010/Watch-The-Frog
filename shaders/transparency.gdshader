shader_type canvas_item;

uniform float transparency = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.a -= transparency;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
