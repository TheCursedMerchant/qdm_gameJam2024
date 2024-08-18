class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var baseSpeed := 600.0
@export var scale_size := Vector2.ONE
@export var dashSpeed := 3000.0
@export var playerState := System.PLAYER_STATES.IDLE
@export var maxDashCharge := 1.0
@export var dashChargeRate := 0.1
@export var speedGrowth = 50.00 

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite
@onready var eating = $Eating

var fleshChunkScene := preload("res://scenes/flesh_chunk.tscn")
var dashCharge := 0.0
var overShrink := false
var fleshChunkPool := ScenePool.new(1)
var experience := 0
var evolveExp := 1 
var currentSpeed := baseSpeed

const minScale := Vector2(0.5, 0.5)
const maxScale := Vector2(1000, 1000)
const minScaleSpeed := 0.3
const maxScaleSpeed := 4
const zoomSpeed := Vector2(0.003, 0.003)

signal charge(zoomRate: Vector2)
signal charge_release
signal death

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
				velocity.x = (h_direction * currentSpeed) #/ clampf(scale_size.x * 1.5, minScaleSpeed, maxScaleSpeed)
			else : 
				velocity.x = move_toward(velocity.x, 0, currentSpeed / 5)
				
			if v_direction :
				velocity.y = (v_direction * currentSpeed) #/ clamp((scale_size.y * 1.5), minScaleSpeed, maxScaleSpeed)
			else :
				velocity.y = move_toward(velocity.y, 0, currentSpeed / 5)
				
		System.PLAYER_STATES.CHARGE :
			Engine.time_scale = 0.3
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click")) :
				emit_signal("charge", zoomSpeed)
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				emit_signal("charge_release")
				grow( -(dashCharge / 3) )
				var callback = func() : 
					fleshChunkPool.getLastScene().updateSize(scale_size * 0.5)
					fleshChunkPool.getLastScene().isEdible = false
					fleshChunkPool.getLastScene().startTimer()
				fleshChunkPool.addAtPosition(global_position + (dash_direction * -100), addChunk, callback)
				playerState = System.PLAYER_STATES.DASH
				
		System.PLAYER_STATES.DASH : 
			velocity += (dash_direction * dashSpeed * dashCharge).round()
			dashCharge = 0
			playerState = System.PLAYER_STATES.IDLE
			
	# Squash and Stretch
	sprite.scale.x = lerp(sprite.scale.x, scale_size.x, 0.1)
	sprite.scale.y = lerp(sprite.scale.y, scale_size.y, 0.1)
		
	move_and_slide()
	
func addChunk() -> FleshChunk : 
	var newChunkInstance: FleshChunk = fleshChunkScene.instantiate()
	newChunkInstance.size_scale = scale_size * 0.5
	newChunkInstance.isEdible = false
	get_tree().root.add_child(newChunkInstance)
	newChunkInstance.startTimer()
	return newChunkInstance
	
func grow(rate: float, exp: float = 0) -> void :
	var growthVector = scale_size + Vector2(rate, rate)
	var newScale = clamp(growthVector, minScale, maxScale)
	
	scale_size = newScale
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	sprite.scale =  clamp(sprite.scale + Vector2(-0.6 , 0.75), minScale, maxScale)
	
	if(rate > 0) :
		overShrink = false
		experience += exp
		if(experience >= evolveExp) : 
			evolve()
		
	if (growthVector < minScale) :
		if (overShrink) :
			take_damage()
		else : 
			overShrink = true
			
func evolve() : 		
	System.player_level += 1 
	experience = 0
	currentSpeed = baseSpeed + (speedGrowth * System.player_level)
	evolveExp *= 1.3
	
	print("Player level after evolving : ", System.player_level)
	if(System.player_level < 3) :
		sprite.texture = GameRes.playerTextures[0]	
	elif(System.player_level < 7) : 
		sprite.texture = GameRes.playerTextures[1]
	elif(System.player_level < 12): 
		sprite.texture = GameRes.playerTextures[2]

func devolve() : 
	System.player_level -= 1
	experience = 0
	evolveExp -= evolveExp * 0.3
	scale_size *= 0.5 
	
	print("Player level after devolving : ", System.player_level)
	if(System.player_level < 3) :
		sprite.texture = GameRes.playerTextures[0]	
	elif(System.player_level < 7) : 
		sprite.texture = GameRes.playerTextures[1]
	elif(System.player_level < 12): 
		sprite.texture = GameRes.playerTextures[2]
		
	System.player_level = System.player_level	
		
func take_damage() :
	devolve()
	if (System.player_level < 0) : 
		print("Player Died!")
		emit_signal("death")
		#get_tree().call_deferred("change_scene_to_file", "res://scenes/death.tscn")
		
func updateSizeScale(scale : float) : 
	var newScale := Vector2(scale, scale)
	scale_size = newScale
	sprite.scale = scale_size
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	
	
