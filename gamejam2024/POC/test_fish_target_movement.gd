extends Area2D

@export
var size :float = 10
var speed :float = 1.0

@onready
var sprite = $Fish_Target

# Scaling the fish.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.global_position.x += speed
