class_name Hunter
extends CharacterBody2D

@export var direction := Vector2.RIGHT
@export var baseSpeed = 300

@onready var huntingTimer:= $HuntTimer

# The fish does not immediately start hunting the player.
var isHunting := false
var player: CharacterBody2D

func _ready() -> void:
	huntingTimer.start()
	
func _process(delta: float) -> void:
	fish_movement()

func fish_movement():
	if isHunting:
		player = System.player_body
		velocity = position.direction_to(player.position) * baseSpeed
	else:
		velocity = direction * baseSpeed
	move_and_slide()
	
func _on_hunt_timer_timeout() -> void:
	isHunting = true
