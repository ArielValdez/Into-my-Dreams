shader_type canvas_item;

void vertex() {
	UV.x += TIME * 0.002;
	UV.y += TIME * 0.001;
}
