class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var SPEED = 500.0
@export var size = 1
@export var dash_speed = 2750.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	var dash_direction := global_position.direction_to(get_global_mouse_position())
	
	if(Input.is_action_just_pressed("left_click")) :
		print("Dash direction is : ", dash_direction)
		velocity += (dash_direction * dash_speed).round()
		
	if h_direction:
		velocity.x = h_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 5)
		
	if v_direction:
		velocity.y = v_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED / 5)
		
	move_and_slide()
	
func grow(rate: float) -> void :
	var growthVector = Vector2(rate, rate)
	sprite.scale += growthVector
	collisionShape.scale += growthVector
	
func die() : 
	sprite.modulate = Color(0, 0, 254, 1)
	print("Player Died!")
	
