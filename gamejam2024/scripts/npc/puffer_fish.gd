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
	speed = 100
	global_position += position.direction_to(player.position) * speed * delta
	var player_distance = position.distance_to(player.position) # 200 seems to be a good distance
	if player_distance <= 200.0001:
		attack()
	
func attack():
	#var fired = stinger.instantiate()
	print("I attack.")
