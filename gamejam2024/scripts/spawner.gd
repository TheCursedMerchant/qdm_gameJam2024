class_name Spawner
extends Node2D

var fish_scene = preload("res://scenes/fish.tscn")
var starting_position_range = randi_range(-250,0)

@export var initial_start := true
@export var fish_direction = Vector2.RIGHT
@export var right_spawn := true
@export var isActive := true

@onready var spawn_timer := $Timer

var spawnPool : ScenePool = ScenePool.new(3)

func _process(delta: float) -> void:
	if initial_start && isActive:
		spawn_timer.start()
		initial_start = false
		
	if(right_spawn) : 
		global_position = Vector2(-25, 0)
	else :
		global_position = Vector2(get_viewport().get_visible_rect().size.x + 25, 0)

func _on_timer_timeout() -> void:
	spawn_timer.start(randf_range(.5,2.5))
	
	spawnPool.addAtPosition(
		Vector2( global_position.x,randi_range(25,get_viewport_rect().size.y) ), 
		spawn_fish)

func spawn_fish() -> Fish: 
	var new_fish : Fish = fish_scene.instantiate()
	new_fish.direction = fish_direction
	add_child(new_fish)
	return new_fish
	
