class_name Food
extends Area2D

@export_category("Stats")
@export var growth_value = 0.05
@export var size_scale = Vector2.ONE

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

func _ready() -> void :
	connect("body_entered", _on_body_entered)
	sprite.scale = size_scale
	collisionShape.scale = size_scale

# Compare Player size to Food size and determine 
# if food is eaten or player is eaten
func _on_body_entered(body: Node2D) -> void:
	var sprite_size = sprite.get_rect().size * sprite.scale
	if(body.get_groups().has("Player")) :
		var player : Player = body
		var body_sprite_size = player.sprite.get_rect().size * player.sprite.scale
		if(sprite_size <=  body_sprite_size and player.playerState == System.PLAYER_STATES.IDLE) :
			player.grow(growth_value)
			queue_free()
		else :
			player.die()
