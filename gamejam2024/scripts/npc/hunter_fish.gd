class_name Hunter
extends "res://scripts/food/food.gd"

@export var direction := Vector2.RIGHT
@export var baseSpeed = 300
@export var shrinkValue = 0.05

@onready var huntingTimer:= $HuntTimer

# The fish does not immediately start hunting the player.
var isHunting := false
var player: CharacterBody2D

func _ready() -> void:
	huntingTimer.start()
	huntingTimer.connect('timeout',_on_hunt_timer_timeout)
	connect("body_entered",_on_body_entered_hunter)
	player = System.player_body
	
func _process(delta: float) -> void:
	fish_movement(delta)

func fish_movement(delta):
	if isHunting:
		global_position += position.direction_to(player.position) * baseSpeed * delta
	else:
		global_position += direction * baseSpeed * delta
	
func _on_hunt_timer_timeout() -> void:
	isHunting = true
	
func _on_body_entered_hunter(body: Node2D):
	if body.get_groups().has("Player"):
		var player : Player = body
		if (!player.isRecovery):
			#player.grow(-shrinkValue)
			#player.take_damage()
			isHunting = false
			huntingTimer.start()
	
