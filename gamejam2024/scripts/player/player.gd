class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var baseSpeed := 200.0
@export var scale_size := Vector2.ONE
@export var dashSpeed := 3000.0
@export var playerState := System.PLAYER_STATES.IDLE
@export var maxDashCharge := 1.0
@export var dashChargeRate := 0.1
@export var speedGrowth = 25.00

@export_category("Stats") 
@export var invulnerabilityTime := 1.0
@export var maxAmmo : int = 3

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite
@onready var eating = $Eating
@onready var damageTimer : Timer = $DamageTimer

var fleshChunkScene := preload("res://scenes/flesh_chunk.tscn")
var fleshChunkPool := ScenePool.new(2)

var waterMissileScene := preload("res://scenes/water_missle.tscn")
var waterMissilePool := ScenePool.new(10)
var waterMissileSpeed := 1000.00

var dashCharge := 0.0
var overShrink := false
var currentSpeed := baseSpeed
var isRecovery := false
var ammo : int = 0

const minScale := Vector2(0.5, 0.5)
const maxScale := Vector2(1000, 1000)
const minScaleSpeed := 0.3
const maxScaleSpeed := 4
const zoomSpeed := Vector2(0.003, 0.003)
const gravity := 20.00
const maxSpeed := 600.00

signal charge(zoomRate: Vector2)
signal charge_release
signal death
signal damage

func _ready() -> void:
	damageTimer.connect("timeout", on_recovery_finished)
	System.player_body = self
	
func on_recovery_finished() : 
	isRecovery = false
	sprite.self_modulate.a = 1.0
	
func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	var dash_direction := global_position.direction_to(get_global_mouse_position())
	
	arrow_sprite.look_at(get_global_mouse_position())
	
	match playerState :
		
		System.PLAYER_STATES.IDLE :  
			if(Input.is_action_just_pressed("left_click")) :
				if(ammo > 0) : 
					playerState = System.PLAYER_STATES.CHARGE
				else :
					emit_signal("damage")
					
			if h_direction:
				if h_direction > 0 : 
					sprite.flip_h = false
				else : 
					sprite.flip_h = true 
				velocity.x = clampf(velocity .x + (h_direction * currentSpeed), -maxSpeed, maxSpeed) #/ clampf(scale_size.x * 1.5, minScaleSpeed, maxScaleSpeed)
			else : 
				velocity.x = move_toward(velocity.x, 0, currentSpeed / 5)
				
			if v_direction :
				velocity.y = clampf(velocity.y + (v_direction * currentSpeed), -maxSpeed, maxSpeed) #/ clamp((scale_size.y * 1.5), minScaleSpeed, maxScaleSpeed)
			#else :
				#velocity.y = move_toward(velocity.y, 0, currentSpeed / 5)
				
		System.PLAYER_STATES.CHARGE :
			Engine.time_scale = 0.2
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click") && dashCharge < 1.0) :
				emit_signal("charge", zoomSpeed)
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				ammo -= 1
				emit_signal("charge_release")
				emit_signal("damage")
				grow( -(dashCharge / 3) )
				#var callback = func() : 
					#fleshChunkPool.getLastScene().updateSize(scale_size * 0.5)
					#fleshChunkPool.getLastScene().isEdible = false
					#fleshChunkPool.getLastScene().velocity = -dash_direction * currentSpeed * dashCharge
					#fleshChunkPool.getLastScene().startTimer()
				#fleshChunkPool.addAtPosition(
					#global_position + (dash_direction * -100), 
					#func() : return addChunk(-dash_direction), 
					#callback)
					
				waterMissilePool.addAtPosition(
					global_position + (dash_direction * -100), 
					func() : return addWaterMissle(dash_direction), 
					func() : reactivateWaterMissile(dash_direction))

				playerState = System.PLAYER_STATES.DASH
				
		System.PLAYER_STATES.DASH : 
			#velocity += (dash_direction * dashSpeed * dashCharge).round()
			dashCharge = 0
			Engine.time_scale = 1.0
			playerState = System.PLAYER_STATES.IDLE
			
		System.PLAYER_STATES.DEAD :
			sprite.flip_v = true 
			velocity.y = - 100
			
	# Squash and Stretch
	sprite.scale.x = lerp(sprite.scale.x, scale_size.x, 0.1)
	sprite.scale.y = lerp(sprite.scale.y, scale_size.y, 0.1)
	
	# Fade alpha back to opaque
	sprite.self_modulate.a = lerp(sprite.self_modulate.a, 1.0, 0.05)
	
	# Apply Weight
	velocity.y = min(velocity.y + (scale_size.y * gravity), maxSpeed)
	
		
	move_and_slide()
	
func addChunk(moveDirection : Vector2) -> FleshChunk : 
	var newChunkInstance: FleshChunk = fleshChunkScene.instantiate()
	newChunkInstance.size_scale = scale_size * 0.5
	newChunkInstance.isEdible = false
	newChunkInstance.velocity = moveDirection * currentSpeed * dashCharge
	get_tree().root.add_child(newChunkInstance)
	newChunkInstance.startTimer()
	return newChunkInstance
	
func addWaterMissle(moveDirection : Vector2) -> WaterMissile :
	var waterMissile: WaterMissile = waterMissileScene.instantiate()
	waterMissile.direction = moveDirection
	waterMissile.rotation = Vector2.RIGHT.angle_to(moveDirection)
	get_tree().root.add_child(waterMissile)
	waterMissile.updateScale(scale_size)
	return waterMissile
	
func reactivateWaterMissile( moveDirection : Vector2 ) :
	waterMissilePool.getLastScene().direction = moveDirection
	waterMissilePool.getLastScene().rotation = Vector2.RIGHT.angle_to(moveDirection)
	waterMissilePool.getLastScene().isActive = true
	waterMissilePool.getLastScene().updateScale(scale_size)
	
func grow(rate: float) -> void :
	var growthVector = scale_size + Vector2(rate, rate)
	var newScale = clamp(growthVector, minScale, maxScale)
	
	scale_size = newScale
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	sprite.scale += Vector2(-0.6 , 0.75)
	#sprite.scale = clamp(sprite.scale + Vector2(-0.6 , 0.75), minScale, maxScale)
	
	if(rate > 0) :
		emit_signal("damage")
		overShrink = false
			
func evolve() : 		
	System.player_level += 1 
	System.player_xp = 0
	System.evolve_xp = round(System.evolve_xp * 1.3)
	System.remaining_xp = System.evolve_xp - System.player_xp
	
	currentSpeed = baseSpeed + (speedGrowth * System.player_level)
	
	if(System.player_level < 5) :
		sprite.texture = GameRes.playerTextures[0]	
	elif(System.player_level < 9) : 
		sprite.texture = GameRes.playerTextures[1]
	else: 
		sprite.texture = GameRes.playerTextures[2]

func devolve() : 
	System.player_level -= 1
	System.player_xp = 0
	System.evolve_xp = round(System.evolve_xp * 0.7)
	System.remaining_xp = System.evolve_xp - System.player_xp
	
	if(System.player_level < 5) :
		sprite.texture = GameRes.playerTextures[0]	
	elif(System.player_level < 9) : 
		sprite.texture = GameRes.playerTextures[1]
	else: 
		sprite.texture = GameRes.playerTextures[2]
		
func take_damage() :
	emit_signal("damage")
	devolve()
	sprite.self_modulate.a = 0.3
	isRecovery = true
	damageTimer.start(invulnerabilityTime)
	if (System.player_level < 0) : 
		playerState = System.PLAYER_STATES.DEAD
		emit_signal("death")

func eat(growth_value : float, exp: int): 
	eating.play()
	grow(growth_value)
	ammo += 1
	System.player_xp += exp
	if(System.player_xp >= System.evolve_xp) : 
		evolve()
		
func updateSizeScale(scale : float) : 
	var newScale := Vector2(scale, scale)
	scale_size = newScale
	sprite.scale = scale_size
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	
	
