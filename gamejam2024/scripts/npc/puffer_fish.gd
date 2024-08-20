class_name PufferFish
extends "res://scripts/npc/fish.gd"

var stingerScene = preload("res://scenes/puffer_fish_stinger.tscn")
var player: CharacterBody2D
var stingerPool = ScenePool.new(6)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomizeTexture = false
	super._ready()
	player = System.player_body
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	fish_movement(delta)
	

# The movement of the fish.
func fish_movement(delta):
	speed = 100
	global_position += position.direction_to(player.position) * speed * delta
	var player_distance = position.distance_to(player.position) # 200 seems to be a good distance
	if player_distance <= 200.0001:
		attack()

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
	attackStinger.getLastScene().rotation = Vector2.RIGHT.angle_to(moveDirection)
	attackStinger.getLastScene().isActive = true
	attackStinger.getLastScene().updateScale(size_scale)
	
func attack():
	var target_direction = position.direction_to(player.position)
	stingerPool.addAtPosition(global_position,
		func(): return addPufferStinger(target_direction),
		func(): reactivatePufferStinger(target_direction))
	print("I attack.")
