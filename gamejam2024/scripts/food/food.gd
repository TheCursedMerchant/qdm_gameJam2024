class_name Food
extends Area2D

@export_category("Stats")
@export var growth_value = 0.05
@export var size_scale = Vector2.ONE
@export var off_screen_location := Vector2(-1000, 0)

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

var isActive := true

func _ready() -> void :
	connect("body_entered", _on_body_entered)
	sprite.scale = size_scale
	collisionShape.scale = size_scale

# Compare Player size to Food size and determine 
# if food is eaten or player is eaten"res://scenes/scoreboard.tscn"
func _on_body_entered(body: Node2D) -> void:
	var sprite_size = sprite.get_rect().size * sprite.scale
	if(body.get_groups().has("Player")) :
		var player : Player = body
		var body_sprite_size = player.sprite.get_rect().size * player.sprite.scale
		if(sprite_size <=  body_sprite_size and player.playerState == System.PLAYER_STATES.IDLE) :
			player.grow(growth_value)
			
			# Adds a point to the player total score.
			System.score += 1
			#queue_free()
			deactivate()
		else :
			player.die()
			
func deactivate() : 
	isActive = false
	global_position = off_screen_location
	
func reactivate() :
	isActive = true
