extends Node

@onready var collision_shape : CollisionShape2D = $Area2D/CollisionShape2D

@export var tilemap : TileMap

var _world_size : Vector2

func _ready() -> void:
	if tilemap != null:
		_world_size = Manager.get_world_size(tilemap)
		
		var shape = RectangleShape2D.new()
		
		shape.size = _world_size
		collision_shape.set_shape(shape)
		collision_shape.position = abs(shape.get_rect().position)
		
		print_debug("World Wraps boundary")
		print_debug(_world_size)
		print_debug(collision_shape.shape.get_rect().size)
		print_debug(collision_shape.position)
	pass

func _on_area_2d_body_exited(body : Node) -> void:
	if body is Movements:
		print_debug("exiting world boundaries")
		print_debug(body.position)
		
		if body.position.x >= _world_size.x:
			body.position.x = 16
		if body.position.x < 0:
			body.position.x = _world_size.x - 16
		if body.position.y >= _world_size.y:
			body.position.y = 32
		if body.position.y < 0:
			body.position.y = _world_size.y
		pass
	pass
