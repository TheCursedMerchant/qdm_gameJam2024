class_name Food
extends Area2D

@export_category("Stats")
@export var growth_value = 0.2

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

# Compare Player size to Food size and determine 
# if food is eaten or player is eaten
func _on_body_entered(body: Node2D) -> void:
	var sprite_size = sprite.get_rect().size * sprite.scale
	if(body.get_groups().has("Player")) :
		var player : Player = body
		var body_sprite_size = player.sprite.get_rect().size * player.sprite.scale
		if(sprite_size <=  body_sprite_size) :
			player.grow(growth_value)
			queue_free()
		else :
			player.die()
