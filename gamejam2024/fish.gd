extends "res://scripts/food/food.gd"

@export_category("movement")
@export var speed : float = 2.0
@export var direction := Vector2.RIGHT
@export var size_scale := Vector2(1, 1)

func random_size_scale():
	var size_scale := randf_range(0,2)
	return Vector2(size_scale, size_scale)
	
func _ready() -> void:
	#sprite.scale = size_scale
	#collisionShape.scale = size_scale
	sprite.scale = random_size_scale()
	collisionShape.scale = random_size_scale()
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed
