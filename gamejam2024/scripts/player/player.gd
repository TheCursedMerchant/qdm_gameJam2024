class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var SPEED = 500.0
@export var size = 1
@export var dashSpeed = 2800.0
@export var playerState = PLAYER_STATES.IDLE
@export var maxDashCharge = 1.0
@export var dashChargeRate = 0.1

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite

var dashCharge = 0.0

func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	var dash_direction := global_position.direction_to(get_global_mouse_position())
	
	arrow_sprite.look_at(get_global_mouse_position())
	
	match playerState :
		
		PLAYER_STATES.IDLE :  
			if(Input.is_action_just_pressed("left_click")) :
				playerState = PLAYER_STATES.CHARGE
			if h_direction:
				velocity.x = h_direction * SPEED
			else :
				velocity.x = move_toward(velocity.x, 0, SPEED / 5)
				
			if v_direction :
				velocity.y = v_direction * SPEED
			else :
				velocity.y = move_toward(velocity.y, 0, SPEED / 5)
				
		PLAYER_STATES.CHARGE :
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click")) :
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				playerState = PLAYER_STATES.DASH
				
		PLAYER_STATES.DASH : 
			velocity += (dash_direction * dashSpeed * dashCharge).round()
			dashCharge = 0
			playerState = PLAYER_STATES.IDLE
		
	move_and_slide()
	
func grow(rate: float) -> void :
	var growthVector = Vector2(rate, rate)
	sprite.scale += growthVector
	collisionShape.scale += growthVector
	arrow_sprite.scale += growthVector
	
func die() : 
	sprite.modulate = Color(0, 0, 254, 1)
	print("Player Died!")
	
enum PLAYER_STATES {
	IDLE,
	CHARGE,
	DASH
}
