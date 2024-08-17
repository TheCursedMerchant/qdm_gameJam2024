class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed := 750.0
@export var scale_size := Vector2.ONE
@export var dashSpeed := 3500.0
@export var playerState := System.PLAYER_STATES.IDLE
@export var maxDashCharge := 1.0
@export var dashChargeRate := 0.1

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite

var fleshChunkScene := preload("res://scenes/flesh_chunk.tscn")
var dashCharge := 0.0
var overShrink := false

const minScale := Vector2(0.2, 0.2)
const maxScale := Vector2(1000, 1000)

func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	var dash_direction := global_position.direction_to(get_global_mouse_position())
	
	arrow_sprite.look_at(get_global_mouse_position())
	
	match playerState :
		
		System.PLAYER_STATES.IDLE :  
			Engine.time_scale = 1.0
			if(Input.is_action_just_pressed("left_click")) :
				playerState = System.PLAYER_STATES.CHARGE
			if h_direction:
				velocity.x = (h_direction * speed) / scale_size.x
			else :
				velocity.x = move_toward(velocity.x, 0, speed / 5)
				
			if v_direction :
				velocity.y = (v_direction * speed) / scale_size.y
			else :
				velocity.y = move_toward(velocity.y, 0, speed / 5)
				
		System.PLAYER_STATES.CHARGE :
			Engine.time_scale = 0.3
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click")) :
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				create_chunk(dash_direction * -1, scale_size * 0.5, dashCharge / 3)
				playerState = System.PLAYER_STATES.DASH
				
		System.PLAYER_STATES.DASH : 
			velocity += (dash_direction * dashSpeed * dashCharge).round()
			dashCharge = 0
			playerState = System.PLAYER_STATES.IDLE
		
	move_and_slide()
	
func create_chunk(direction: Vector2, size: Vector2, shrink_amount: float) : 
	var newChunkInstance: Food = fleshChunkScene.instantiate()
	newChunkInstance.size_scale = size
	newChunkInstance.global_position = global_position + (direction * 100)
	grow(-shrink_amount)
	get_tree().root.add_child(newChunkInstance)
	
func grow(rate: float) -> void :
	var growthVector = scale_size + Vector2(rate, rate)
	var newScale = clamp(growthVector, minScale, maxScale)
	
	scale_size = newScale
	sprite.scale = scale_size
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	
	if(rate > 0) :
		overShrink = false
		
	if (growthVector < minScale) :
		if (overShrink) :
			die()
		else : 
			print("Max shrink!")
			overShrink = true
		
	
func die() : 
	sprite.modulate = Color(0, 0, 254, 1)
	print("Player Died!")
	
