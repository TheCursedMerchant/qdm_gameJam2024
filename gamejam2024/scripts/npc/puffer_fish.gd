class_name PufferFish
extends "res://scripts/npc/fish.gd"

var stinger = preload("res://scenes/puffer_fish_stinger.tscn")
var player: CharacterBody2D

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
	var moveDirection = global_position.direction_to(player.global_position)
	var player_distance = global_position.distance_to(player.global_position) # 200 seems to be a good distance
	if player_distance <= 200.00:
		attack()
		
	sprite.flip_h = moveDirection.x < 0
	global_position += moveDirection * speed * delta
	
func attack():
	#var fired = stinger.instantiate()
	print("I attack.")
	
func deactivate() : 
	super.deactivate()
	System.activePuffers -= 1
