extends CharacterBody2D

@onready var directions = [Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN,Vector2.UP]
@onready var huntingTimer:= $HuntTimer

@export var baseSpeed = 300
var player: CharacterBody2D

# The fish does not immediately start hunting the player.
var isHunting := false


func _ready() -> void:
	huntingTimer.start()
	isHunting = true
	
func _process(delta: float) -> void:
	move_and_slide()

func fish_movement():
	pass

func targeted_movement():
	if isHunting:
		player = System.player_body
		velocity = position.direction_to(player.position) * baseSpeed
	move_and_slide()
	
