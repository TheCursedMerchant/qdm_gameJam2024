class_name Fish
extends "res://scripts/food/food.gd"

@export_category("Movement")
@export var speed : float = 1000.0
@export var direction := Vector2.RIGHT

func _ready() -> void :
	var size_scale_value = randf_range(0.25, 4)
	size_scale = Vector2(size_scale_value,size_scale_value)
	super._ready()

func _physics_process(delta: float) -> void :
	if(isActive) : 
		global_position += (direction * speed) * delta
	#if(global_position < Vector2(-100, 100) or global_position > (get_viewport_rect().size + Vector2(100, 100)) ) : 
		#queue_free()
		
func reactivate() :
	var size_scale_value = randf_range(0.25, 4)
	updateSize(Vector2(size_scale_value,size_scale_value))
