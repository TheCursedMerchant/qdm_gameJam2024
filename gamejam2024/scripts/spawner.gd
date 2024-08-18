class_name Spawner
extends Node2D

var fish_scene = preload("res://scenes/fish.tscn")
var starting_position_range = randi_range(-250,0)

@export var initial_start := true
@export var fish_direction = Vector2.RIGHT
@export var spawnSide = Vector2.RIGHT
@export var isActive := true

@onready var spawn_timer := $Timer

var spawnPool : ScenePool = ScenePool.new(3)

func _ready() -> void :
	pass

func _process(delta: float) -> void:
	if initial_start && isActive:
		spawn_timer.start()
		initial_start = false
		
func _physics_process(delta: float) -> void:
	match spawnSide : 
		Vector2.LEFT :
			global_position = Vector2(-25, 0)
		Vector2.RIGHT :
			global_position = Vector2(get_viewport().get_visible_rect().size.x + 25, 0)
		Vector2.UP :
			global_position = Vector2(get_viewport().get_visible_rect().size.x / 2, -25)
		Vector2.DOWN :
			global_position = Vector2(get_viewport().get_visible_rect().size.x / 2, get_viewport().get_visible_rect().size.y + 25)  

func _on_timer_timeout() -> void:
	spawn_timer.start(randf_range(.5,2.5))
	
	spawnPool.addAtPosition(
		Vector2( global_position.x,randi_range(25,get_viewport_rect().size.y) ), 
		spawn_fish,
		func() : )

func spawn_fish() -> Fish: 
	var new_fish : Fish = fish_scene.instantiate()
	new_fish.direction = fish_direction
	add_child(new_fish)
	if(fish_direction.x > 0 ):
		new_fish.sprite.flip_h = false
	elif(fish_direction.x < 0):
		new_fish.sprite.flip_h = true
		
	if(fish_direction.y > 0 ):
		new_fish.sprite.flip_v = true
	elif(fish_direction.y < 0):
		new_fish.sprite.flip_v = false
		
	return new_fish
	
