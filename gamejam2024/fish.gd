class_name Fish
extends "res://scripts/food/food.gd"

@onready var squishTimer := $SquishTimer

@export_category("Movement")
@export var speed : float = 1000.0
@export var direction := Vector2.RIGHT

var childrenFishScene := preload("res://scenes/fish.tscn")
var fishPool := ScenePool.new(2)
var isSplit := false

func _ready() -> void :
	experience = 10
	sprite.texture = GameRes.get_random_texture()
	var size_scale_value = randf_range(0.25, 4)
	size_scale = Vector2(size_scale_value,size_scale_value)	
	squishTimer.connect("timeout", on_squish_timeout)
	super._ready()

func _process(delta) :
	sprite.scale.x = lerp(sprite.scale.x, size_scale.x, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, size_scale.y, 0.2)

func _physics_process(delta: float) -> void :
	if(isActive) : 
		global_position += (direction * speed) * delta
		
func reactivate() :
	isActive = true
	var size_scale_value = randf_range(0.25, 4)
	sprite.texture = GameRes.get_random_texture()
	updateSize(Vector2(size_scale_value,size_scale_value))
	
func take_damage() :
	sprite.scale += Vector2(-0.6 , 0.75)
	fishPool.call_deferred("addAtPosition" ,global_position + Vector2(60, 0), addFish, reactivateFish)
	fishPool.call_deferred("addAtPosition" ,global_position + Vector2(-60 ,0), addFish, reactivateFish)
	#squishTimer.start(0.2)
	deactivate()
	
func addFish() -> Fish : 
	var fishInstance : Fish = childrenFishScene.instantiate()
	fishInstance.speed = speed
	fishInstance.direction = direction
	fishInstance.rotation = rotation
	fishInstance.isSplit = true
	get_tree().root.add_child(fishInstance)
	fishInstance.sprite.flip_h = sprite.flip_h
	fishInstance.updateSize(size_scale * 0.5)
	fishInstance.sprite.texture = sprite.texture
	return fishInstance
	
func reactivateFish() : 
	var lastScene : Fish = fishPool.getLastScene()
	lastScene.speed = speed
	lastScene.direction = direction
	lastScene.sprite.flip_h = sprite.flip_h
	lastScene.rotation = rotation
	lastScene.updateSize(size_scale * 0.5)
	lastScene.isSplit = true
	lastScene.sprite.texture = sprite.texture
	
func on_squish_timeout() : 
	deactivate()
	
