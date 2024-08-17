extends "res://scripts/food/food.gd"

@export_category("movement")
@export var speed : float = 20.0
@export var direction := Vector2.RIGHT
@export var size_scale := Vector2(1, 1)

func _ready() -> void:
	sprite.scale = size_scale
	collisionShape.scale = size_scale

func _physics_process(delta: float) -> void:
	global_position += direction * speed
