class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var SPEED = 500.0
@export var size = 1

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	
	if h_direction:
		velocity.x = h_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if v_direction:
		velocity.y = v_direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func grow(rate: float) -> void :
	var growthVector = Vector2(rate, rate)
	sprite.scale += growthVector
	collisionShape.scale += growthVector
	
func die() : 
	print("Player Died!")
	
