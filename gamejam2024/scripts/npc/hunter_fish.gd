class_name Hunter
extends "res://scripts/npc/fish.gd"

@export var huntingSpeed = 100

@onready var huntingTimer:= $HuntTimer
@onready var baseSprite := $CalmSprite
@onready var aggroSprite := $AggroSprite

# The fish does not immediately start hunting the player.
var isHunting := false
var player: CharacterBody2D

func _ready() -> void:
	huntingTimer.start()
	huntingTimer.connect('timeout',_on_hunt_timer_timeout)
	connect("body_entered",_on_body_entered_hunter)
	player = System.player_body

func _physics_process(delta: float) -> void:
	if isHunting:
		aggroSprite.show()
		baseSprite.hide()
	else:
		aggroSprite.hide()
		baseSprite.show()
	fish_movement(delta)

func fish_movement(delta):
	speed=8000
	if isHunting:
		global_position += global_position.direction_to(player.position) * huntingSpeed * delta
	else:
		global_position += direction * speed * delta

func _on_hunt_timer_timeout() -> void:
	var currentSize = sprite.get_rect().size * sprite.scale
	var currentPlayerSize = player.sprite.get_rect().size * player.scale_size
	if currentSize > currentPlayerSize:
		isHunting = true

func _on_body_entered_hunter(body: Node2D):
	if body.get_groups().has("Player"):
		var player : Player = body
		if (!player.isRecovery):
			isHunting = false
			huntingTimer.start()
			
func deactivate() : 
	super.deactivate()
	System.activeHunters -= 1
