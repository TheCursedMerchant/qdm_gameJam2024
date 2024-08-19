extends "res://scripts/food/food.gd"
class_name FleshChunk

@export var eatCooldown = 0.5
@export var waterFriction = 5.00

var eatTimer : Timer
var velocity := Vector2.ZERO

func _ready() -> void:
	eatTimer = $Timer
	super._ready()
	eatTimer.connect("timeout", _on_timer_timeout)
	eatTimer.start()
	
func _physics_process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, waterFriction)
	velocity.y = move_toward(velocity.y, 0, waterFriction)
	global_position += velocity * delta

func _on_timer_timeout() :
	eatTimer.stop()
	isEdible = true
	
func startTimer() : 
	eatTimer.start(eatCooldown)
	
