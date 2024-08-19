class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var baseSpeed := 200.0
@export var scale_size := Vector2.ONE
@export var dashSpeed := 1000.0
@export var playerState := System.PLAYER_STATES.IDLE
@export var maxDashCharge := 1.0
@export var dashChargeRate := 0.1
@export var speedGrowth = 25.00
@export var spitForce := 400.00
@export var digestTime := 3.0

@export_category("Stats") 
@export var invulnerabilityTime := 1.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var arrow_sprite : Sprite2D = $ArrowSprite
@onready var eating = $Eating
@onready var damageTimer : Timer = $DamageTimer
@onready var digestTimer : Timer = $DigestTimer

var fleshChunkScene := preload("res://scenes/flesh_chunk.tscn")
var fleshChunkPool := ScenePool.new(10)

var waterMissileScene := preload("res://scenes/water_missle.tscn")
var waterMissilePool := ScenePool.new(10)
var waterMissileSpeed := 1000.00

var dashCharge := 0.0
var overShrink := false
var currentSpeed := baseSpeed
var isRecovery := false
var pointDirection := Vector2.RIGHT

const minScale := Vector2(1.0, 1.0)
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
	digestTimer.connect("timeout", on_digest_timeout)
	System.player_body = self
	
func on_recovery_finished() : 
	isRecovery = false
	sprite.self_modulate.a = 1.0

func on_digest_timeout() :
	if(isFull()) : 
		System.stomachSize = 0
		System.stomachCapacity += 1
		scaleTo(minScale)
	
func _physics_process(delta: float) -> void:
	var h_direction := Input.get_axis("ui_left", "ui_right")
	var v_direction := Input.get_axis("ui_up", "ui_down")
	pointDirection = global_position.direction_to(get_global_mouse_position())
	
	arrow_sprite.look_at(get_global_mouse_position())
	
	match playerState :
		
		System.PLAYER_STATES.IDLE :  
			if(Input.is_action_just_pressed("left_click")) :
				if(isFull()) : 
					playerState = System.PLAYER_STATES.CHARGE
				else :
					emit_signal("damage")
					
			#elif(Input.is_action_just_pressed("right_click")) :
				#if(isFull()) :
					#System.stomachSize = 0
					#System.stomachCapacity += 1
					#scaleTo(minScale) 
				#else : 
					#emit_signal("damage")
					
			if h_direction:
				if h_direction > 0 : 
					sprite.flip_h = false
				else : 
					sprite.flip_h = true 
				velocity.x = clampf(velocity .x + (h_direction * currentSpeed), -maxSpeed, maxSpeed)
			else : 
				velocity.x = move_toward(velocity.x, 0, currentSpeed / 5)
				
			if v_direction :
				velocity.y = clampf(velocity.y + (v_direction * currentSpeed), -maxSpeed, maxSpeed)
				
		System.PLAYER_STATES.CHARGE :
			Engine.time_scale = 0.2
			velocity = Vector2.ZERO
			if(Input.is_action_pressed("left_click") && dashCharge < 1.0) :
				emit_signal("charge", zoomSpeed)
				dashCharge = clamp(dashCharge + dashChargeRate, 0.0, maxDashCharge)
			else : 
				scaleTo(minScale)
				emit_signal("charge_release")
				emit_signal("damage")
				grow( -(dashCharge / 3) )

				waterMissilePool.addAtPosition(
					global_position + (pointDirection * -100), 
					func() : return addWaterMissle(pointDirection), 
					func() : reactivateWaterMissile(pointDirection))

				playerState = System.PLAYER_STATES.DASH
				
		System.PLAYER_STATES.DASH : 
			velocity += (-pointDirection * dashSpeed * dashCharge).round()
			System.stomachSize = 0
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
	newChunkInstance.velocity = moveDirection * spitForce * (1 + randf_range(0.1, .7))
	get_tree().root.add_child(newChunkInstance)
	newChunkInstance.startTimer()
	return newChunkInstance
	
func addWaterMissle(moveDirection : Vector2) -> WaterMissile :
	var waterMissile: WaterMissile = waterMissileScene.instantiate()
	waterMissile.direction = moveDirection
	waterMissile.rotation = Vector2.RIGHT.angle_to(moveDirection)
	waterMissile.hitCallback = func() : emit_signal("damage")
	get_tree().root.add_child(waterMissile)
	waterMissile.updateScale(scale_size)
	return waterMissile
	
func reactivateWaterMissile( moveDirection : Vector2 ) :
	var waterMissile = waterMissilePool.getLastScene()
	waterMissile.direction = moveDirection
	waterMissile.getLastScene().rotation = Vector2.RIGHT.angle_to(moveDirection)
	waterMissile.getLastScene().isActive = true
	waterMissile.getLastScene().updateScale(scale_size)
	
func grow(rate: float) -> void :
	var growthVector = scale_size + Vector2(rate, rate)
	var newScale = clamp(growthVector, minScale, maxScale)
	
	scale_size = newScale
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	sprite.scale += Vector2(-0.6 , 0.75)
	
func scaleTo(_scale: Vector2) -> void:
	var newScale = clamp(_scale, minScale, maxScale)
	
	scale_size = newScale
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	sprite.scale += Vector2(-0.6 , 0.75)


func take_damage() :
	emit_signal("damage")
	sprite.self_modulate.a = 0.3
	isRecovery = true
	damageTimer.start(invulnerabilityTime)
	if (System.stomachSize > 0) :
		scaleTo(minScale)
		var callback = func() : 
			fleshChunkPool.getLastScene().updateSize(scale_size * 0.5)
			fleshChunkPool.getLastScene().isEdible = false
			fleshChunkPool.getLastScene().velocity = pointDirection * spitForce
			fleshChunkPool.getLastScene().startTimer()
		for i in System.stomachSize : 
				fleshChunkPool.call_deferred("addAtPosition",
					global_position + (pointDirection), 
					func() : return addChunk(pointDirection), 
					callback)
	
		System.stomachSize = 0
	else :  
		playerState = System.PLAYER_STATES.DEAD
		emit_signal("death")

func eat(growth_value : float): 
	emit_signal("damage")
	eating.play()
	grow(growth_value)
	System.stomachSize += 1
	if (isFull()) : 
		digestTimer.start(digestTime)

func isFull() : 
	return System.stomachSize >= System.stomachCapacity
		
func updateSizeScale(scale : float) : 
	var newScale := Vector2(scale, scale)
	scale_size = newScale
	sprite.scale = scale_size
	collisionShape.scale = scale_size
	arrow_sprite.scale = scale_size
	
	
