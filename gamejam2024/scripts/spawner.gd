class_name Spawner
extends Node2D

# Loading in the fish spawner.
var fish_spawn = preload("res://scenes/fish.tscn")

# Dynamically create direction.
var starting_position_range = randi_range(-250,0)

@export var initial_start := true
@export var fish_direction = Vector2.RIGHT
@export var right_spawn := true

@onready var spawn_timer := $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if initial_start:
		spawn_timer.start()
		initial_start = false
		
	if(right_spawn) : 
		global_position = Vector2(-25, 0)
	else :
		global_position = Vector2(get_viewport().get_visible_rect().size.x + 25, 0)

func _on_timer_timeout() -> void:
#	Reset the timer.
	spawn_timer.start(randf_range(.5,2.5))
	
	# Spawn the fish.
	var new_fish = fish_spawn.instantiate()
	new_fish.direction = fish_direction
	new_fish.position = Vector2(global_position.x,randi_range(25,get_viewport_rect().size.y))
	add_child(new_fish)
