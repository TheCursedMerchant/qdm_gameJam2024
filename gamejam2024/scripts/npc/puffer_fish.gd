class_name PufferFish
extends "res://scripts/npc/fish.gd"

@export var attackCooldown = 1.0

var stingerScene = preload("res://scenes/puffer_fish_stinger.tscn")
var player: Player
var stingerPool = ScenePool.new(6)
var canAttack := true

@onready var coolDowntimer : Timer = $CooldownTimer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coolDowntimer.connect("timeout", onCooldownTimeout)
	randomizeTexture = false
	super._ready()
	player = System.player_body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	fish_movement(delta)
	
# The movement of the fish.
func fish_movement(delta):
	var moveDirection = global_position.direction_to(player.global_position)
	var player_distance = global_position.distance_to(player.global_position) # 200 seems to be a good distance
	if player_distance <= 400 && canAttack:
		attack()
	sprite.flip_h = moveDirection.x < 0
	global_position += moveDirection * speed * delta

func addPufferStinger(moveDirection: Vector2) -> PufferStinger:
	var attackStinger = stingerScene.instantiate()
	attackStinger.direction = moveDirection
	attackStinger.rotation = Vector2.RIGHT.angle_to(moveDirection)
	get_tree().root.add_child(attackStinger)
	attackStinger.updateScale(size_scale)
	return attackStinger
	
func reactivatePufferStinger(moveDirection: Vector2):
	var attackStinger = stingerPool.getLastScene()
	attackStinger.direction = moveDirection
	attackStinger.rotation = Vector2.RIGHT.angle_to(moveDirection)
	attackStinger.isActive = true
	attackStinger.updateScale(size_scale)
	
func attack():
	canAttack = false
	coolDowntimer.start(attackCooldown)
	var cardinal_direction = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
	#var target_direction = position.direction_to(player.position)
	for target_direction in cardinal_direction:
		stingerPool.addAtPosition(global_position,
			func(): return addPufferStinger(target_direction),
			func(): reactivatePufferStinger(target_direction))
	
func deactivate() : 
	super.deactivate()
	System.activePuffers -= 1
	
func onCooldownTimeout():
	canAttack = true 
