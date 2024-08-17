extends "res://scripts/food/food.gd"

@export_category("Movement")
@export var speed : float = 20.0
@export var direction := Vector2.RIGHT

func _ready() -> void:
	var size_scale_value = randf_range(0.5, 2)
	size_scale = Vector2(size_scale_value,size_scale_value)
	super._ready()

func _physics_process(delta: float) -> void:
	global_position += direction * speed
	
