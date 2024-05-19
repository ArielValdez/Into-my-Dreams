extends Camera2D

const ZERO_LIMIT : float = 0
var super_limits_right : float = limit_right
var super_limits_bottom : float = limit_bottom
var super_limits_left : float = limit_left
var super_limits_top : float = limit_top

func _ready() -> void:
	Manager.resize_camera_limit.connect(resize_map_limit)
	pass

func resize_map_limit(current_scene : WorldScene) -> void:
	enabled = current_scene.enabled_camera_for_scene
	if enabled:
		if current_scene.tilemap != null and !current_scene.is_looping_world:
			print_debug("resizing camera limits")
			var world_size_in_pixels = Manager.get_world_size(current_scene.tilemap)
			limit_right = world_size_in_pixels.x - 64 + current_scene.camera_limit_off_set.x
			limit_bottom = world_size_in_pixels.y - 64 + current_scene.camera_limit_off_set.y
			limit_left = ZERO_LIMIT - current_scene.camera_zero_off_set_limit.x
			limit_top = ZERO_LIMIT - current_scene.camera_zero_off_set_limit.y
			
			print("x size: " + str(limit_right) + ", y size: " + str(limit_bottom))
		elif current_scene.tilemap != null and current_scene.is_looping_world:
			limit_right = super_limits_right
			limit_top = super_limits_top
			limit_bottom = super_limits_bottom
			limit_left = super_limits_left
			pass
		pass
	pass
