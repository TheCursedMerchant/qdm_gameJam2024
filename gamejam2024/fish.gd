class_name Fish
extends "res://scripts/food/food.gd"

@export_category("Movement")
@export var speed : float = 1000.0
@export var direction := Vector2.RIGHT

func _ready() -> void :
	sprite.texture = GameRes.get_random_texture()
	var size_scale_value = randf_range(0.25, 4)
	size_scale = Vector2(size_scale_value,size_scale_value)	
	super._ready()

func _physics_process(delta: float) -> void :
	if(isActive) : 
		global_position += (direction * speed) * delta
		
func reactivate() :
	isActive = true
	var size_scale_value = randf_range(0.25, 4)
	sprite.texture = GameRes.get_random_texture()
	updateSize(Vector2(size_scale_value,size_scale_value))
