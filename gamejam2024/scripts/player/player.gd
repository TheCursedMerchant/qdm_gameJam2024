class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var speed := 600.0
@export var scale_size := Vector2.ONE
@export var dashSpeed := 3000.0
@export var playerState := System.PLAYER_STATES.IDLE
@export var maxDashCharge := 1.0
@export var dashChargeRate := 0.1

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite

var fleshChunkScene := preload("res://scenes/flesh_chunk.tscn")
var dashCharge := 0.0
var overShrink := false
var fleshChunkPool := ScenePool.new(1)

const minScale := Vector2(0.5, 0.5)
const maxScale := Vector2(1000, 1000)
const minScaleSpeed := 0.3
const maxScaleSpeed := 4


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
				if h_direction > 0 : 
					sprite.flip_h = false
				else : 
					sprite.flip_h = true 
				velocity.x = (h_direction * speed) #/ clampf(scale_size.x * 1.5, minScaleSpeed, maxScaleSpeed)
			else : 
				velocity.x = move_toward(velocity.x, 0, speed / 5)
				
			if v_direction :
				velocity.y = (v_direction * speed) #/ clamp((scale_size.y * 1.5), minScaleSpeed, maxScaleSpeed)
			else :
				velocity.y = move_toward(velocity.y, 0, speed / 5)
				
		System.PLAYER_STATES.CHARGE :
			Engine.time_scale = 0.3
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click")) :
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				grow( -(dashCharge / 3) )
				fleshChunkPool.addAtPosition(global_position + (dash_direction * -1), addChunk)
				playerState = System.PLAYER_STATES.DASH
				
		System.PLAYER_STATES.DASH : 
			velocity += (dash_direction * dashSpeed * dashCharge).round()
			dashCharge = 0
			playerState = System.PLAYER_STATES.IDLE
			
	# Squash and Stretch
	sprite.scale.x = lerp(sprite.scale.x, scale_size.x, 0.1)
	sprite.scale.y = lerp(sprite.scale.y, scale_size.y, 0.1)
		
	move_and_slide()
	
func addChunk() -> Food : 
	var newChunkInstance: Food = fleshChunkScene.instantiate()
	newChunkInstance.size_scale = scale_size * 0.5
	get_tree().root.add_child(newChunkInstance)
	return newChunkInstance
	
	
func grow(rate: float) -> void :
	var growthVector = scale_size + Vector2(rate, rate)
	var newScale = clamp(growthVector, minScale, maxScale)
	
	scale_size = newScale
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	
	sprite.scale =  clamp(sprite.scale + Vector2(-0.6 , 0.75), minScale, maxScale)
	
	if(rate > 0) :
		overShrink = false
		
	if (growthVector < minScale) :
		if (overShrink) :
			die()
		else : 
			print("Max shrink!")
			overShrink = true
		
func die() : 
	#sprite.modulate = Color(0, 0, 254, 1)
	print("Player Died!")
	
