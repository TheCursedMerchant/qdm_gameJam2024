extends "res://scripts/food/food.gd"

@export_category("Movement")
@export var speed : float = 20.0
@export var direction := Vector2.RIGHT

func _ready() -> void:
	var randomScale := Vector2(randf_range(0.5, 2), randf_range(0.5, 2))
	sprite.scale = randomScale
	collisionShape.scale = randomScale

func _physics_process(delta: float) -> void:
	global_position += direction * speed
