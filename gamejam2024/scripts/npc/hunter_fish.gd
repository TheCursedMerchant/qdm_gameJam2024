class_name Hunter
extends "res://scripts/npc/fish.gd"

@export var huntingSpeed = 750
@export var aggroRange = 600
@export var huntCooldown = 1.0

@onready var huntTimer := $HuntTimer

var baseTexture = preload("res://assets/art/hunterfish1.png")
var aggroTexture = preload("res://assets/art/hunterfish2.png")

# The fish does not immediately start hunting the player.
var isHunting := false
var canHunt := true
var player: CharacterBody2D

func _ready() -> void:
	connect("body_entered",_on_body_entered_hunter)
	huntTimer.connect("timeout", on_timer_timeout)
	player = System.player_body
	randomizeTexture = false
	super._ready()

func fish_movement(delta) : 
	var moveDirection = global_position.direction_to(player.global_position)
	var player_distance = global_position.distance_to(player.global_position)
	var currentSize = sprite.get_rect().size * sprite.scale
	var currentPlayerSize = player.sprite.get_rect().size * player.scale_size
		
	if player_distance <= aggroRange && currentSize > currentPlayerSize :
		isHunting = true
		
	if isHunting && canHunt:
		sprite.texture = aggroTexture
		sprite.flip_h = moveDirection.x < 0
		global_position += moveDirection * huntingSpeed * delta
	else:
		sprite.texture = baseTexture
		global_position += direction * speed * delta

func _on_body_entered_hunter(body: Node2D):
	if body.get_groups().has("Player"):
		var player : Player = body
		if (!player.isRecovery):
			isHunting = false
			canHunt = false
			sprite.flip_h = direction.x < 0
			huntTimer.start(huntCooldown)
			player.take_damage()
			
func deactivate() : 
	super.deactivate()

func on_timer_timeout(): 
	canHunt = true
