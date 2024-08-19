class_name Fish
extends "res://scripts/food/food.gd"

@onready var squishTimer := $SquishTimer

@export_category("Movement")
@export var speed : float = 850.0
@export var direction := Vector2.RIGHT

var childrenFishScene := preload("res://scenes/food.tscn")
var foodPool := ScenePool.new(2)
var isSplit := false

func _ready() -> void :
	experience = 10
	sprite.texture = GameRes.get_random_texture()
	var size_scale_value = randf_range(0.25, 4)
	size_scale = Vector2(size_scale_value,size_scale_value)	
	squishTimer.connect("timeout", on_squish_timeout)
	super._ready()

func _physics_process(delta: float) -> void :
	if(isActive) : 
		global_position += (direction * speed) * delta
		
	#sprite.scale.x = lerp(sprite.scale.x, size_scale.x, 0.2)
	#sprite.scale.y = lerp(sprite.scale.y, size_scale.y, 0.2)
		
func reactivate() :
	isActive = true
	var size_scale_value = randf_range(0.25, 4)
	sprite.texture = GameRes.get_random_texture()
	updateSize(Vector2(size_scale_value,size_scale_value))
	
func take_damage() :
	sprite.scale += Vector2(-0.6 , 0.75)
	foodPool.call_deferred("addAtPosition" ,global_position + Vector2(-60 ,0), addFood, reactivateFood)
	#squishTimer.start(0.2)
	deactivate()
	
func addFood() -> Food : 
	var foodInstance : Food = childrenFishScene.instantiate()
	get_tree().root.add_child(foodInstance)
	foodInstance.updateSize(size_scale * 0.5)
	foodInstance.sprite.texture = sprite.texture
	foodInstance.sprite.flip_v = true
	foodInstance.friendly = true
	return foodInstance
	
func reactivateFood() : 
	var lastScene : Food = foodPool.getLastScene()
	lastScene.updateSize(size_scale * 0.5)
	lastScene.sprite.texture = sprite.texture
	lastScene.sprite.flip_v = true
	lastScene.friendly = true
	
func on_squish_timeout() : 
	deactivate()
	
