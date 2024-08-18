extends "res://scripts/food/food.gd"
class_name FleshChunk
@export var eatCooldown = 0.5

var eatTimer : Timer

func _ready() -> void:
	eatTimer = $Timer
	super._ready()
	eatTimer.connect("timeout", _on_timer_timeout)
	eatTimer.start()

func _on_timer_timeout() :
	eatTimer.stop()
	isEdible = true
	
func startTimer() : 
	eatTimer.start(eatCooldown)
	
