extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var light : PointLight2D = $TextureLight
@onready var shadow : PointLight2D = $Shadow

@export var light_energy : float = 0.7
@export var light_texture_scale : float = 1.4
@export var enable_light_as_shadow : bool = false
@export var light_filter : int = 0 # 0 = DEFAULT, 1 = PCF5, 2 = PCF13
@export var light_filter_smooth : float = 0.0

@export var shadow_energy : float = 1.0
@export var shadow_texture_scale : float = 0.7
@export var shadow_filter : int = 1 # 0 = DEFAULT, 1 = PCF5, 2 = PCF13
@export var shadow_filter_smooth : float = 2.0
const enable_shadow : bool = true

func _ready():
	if shadow_filter > 2:
		shadow_filter = 2
	elif shadow_filter < 0:
		shadow_filter = 0
	
	if light_filter > 2:
		light_filter = 2
	elif light_filter < 0:
		light_filter = 0
	
	light.energy = light_energy
	light.texture_scale = light_texture_scale
	light.shadow_enabled = enable_light_as_shadow
	light.shadow_filter = light_filter
	light.shadow_filter_smooth = light_filter_smooth
	
	shadow.energy = shadow_energy
	shadow.texture_scale = shadow_texture_scale
	shadow.shadow_enabled = enable_shadow
	shadow.shadow_filter = shadow_filter
	shadow.shadow_filter_smooth = shadow_filter_smooth
	
	if animation.has_animation("lit"):
		animation.play("lit")
	pass
