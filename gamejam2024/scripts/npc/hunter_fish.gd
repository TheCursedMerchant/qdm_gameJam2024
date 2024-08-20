class_name Hunter
extends "res://scripts/npc/fish.gd"

@export var huntingSpeed = 750
@export var aggroRange = 600
@export var huntCooldown = 1.0

@onready var baseSprite := $Sprite2D
@onready var aggroSprite := $AggroSprite
@onready var huntTimer := $HuntTimer

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

func _physics_process(delta: float) -> void:
	if isHunting:
		aggroSprite.show()
		baseSprite.hide()
	else:
		aggroSprite.hide()
		baseSprite.show()
	
	fish_movement(delta)

func fish_movement(delta):
	var moveDirection = global_position.direction_to(player.global_position)
	var player_distance = global_position.distance_to(player.global_position)
	var currentSize = sprite.get_rect().size * sprite.scale
	var currentPlayerSize = player.sprite.get_rect().size * player.scale_size
		
	if player_distance <= aggroRange && currentSize > currentPlayerSize :
		isHunting = true
		
	if isHunting && canHunt:
		print("Hunting!")
		sprite.flip_h = moveDirection.x < 0
		global_position += moveDirection * huntingSpeed * delta
	else:
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
	System.activeHunters -= 1

func on_timer_timeout(): 
	canHunt = true
