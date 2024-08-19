class_name Spawner
extends Node2D

var fish_scene = preload("res://scenes/fish.tscn")
var hunter_scene = preload("res://scenes/hunter_fish.tscn")
var starting_position_range = randi_range(-250,0)

@export var initial_start := true
@export var fish_direction = Vector2.RIGHT
@export var spawnSide = Vector2.RIGHT
@export var isActive := true
@export var isHunterActive := false
@export var spawnIndex : int

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
	
	var spawnPosition : Vector2
	
	if(spawnSide.x != 0) : 
		spawnPosition = Vector2(global_position.x ,randf_range(25, get_viewport_rect().size.y))
	
	if(spawnSide.y != 0) : 
		spawnPosition = Vector2(randf_range(100, get_viewport_rect().size.x), global_position.y)
	
	spawnPool.addAtPosition(
		spawnPosition, 
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
		new_fish.global_rotation_degrees = 90
	elif(fish_direction.y < 0):
		new_fish.global_rotation_degrees = -90
		
	return new_fish

# If timer > n isHunting = active
func spawn_hunter() -> Fish:
	var new_hunter: Fish = hunter_scene.instantiate()
	
	return new_hunter
	
