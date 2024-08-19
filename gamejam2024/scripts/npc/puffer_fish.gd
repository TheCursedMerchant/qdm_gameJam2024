class_name PufferFish
extends "res://scripts/npc/fish.gd"
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
	global_position += global_position.direction_to(player.global_position) * speed * delta
	var player_distance = global_position.distance_to(player.global_position) # 200 seems to be a good distance
	if player_distance <= 200.0001:
		attack()
	
func attack():
	print("I attack.")
	
func deactivate() : 
	super.deactivate()
	System.activePuffers -= 1
