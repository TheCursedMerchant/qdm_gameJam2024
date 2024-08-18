class_name Food
extends Area2D

@export_category("Stats")
@export var growth_value = 0.2
@export var experience := 0
@export var size_scale = Vector2.ONE
@export var off_screen_location := Vector2(-1000, 0)
@export var friendly := false

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D

var isActive := true
var isEdible := true

func _ready() -> void :
	connect("body_entered", _on_body_entered)
	updateSize(size_scale)

# Compare Player size to Food size and determine 
# if food is eaten or player is eaten
func _on_body_entered(body: Node2D) -> void:
	var sprite_size = sprite.get_rect().size * sprite.scale
	if(isEdible && body.get_groups().has("Player")) :
		var player : Player = body
		var body_sprite_size = player.sprite.get_rect().size * player.scale_size
		if((friendly or (sprite_size <=  body_sprite_size and player.playerState == System.PLAYER_STATES.IDLE)) ) :
			player.eating.play()
			player.grow(growth_value, experience)
			if (friendly == false):
				System.score += 1
			deactivate()
		else :
			print("Damage from Food!")
			player.take_damage()
			
func deactivate() : 
	isActive = false
	global_position = off_screen_location
	
func reactivate() :
	isActive = true
	
func updateSize(newSize: Vector2) :
	size_scale = newSize
	sprite.scale = size_scale
	collisionShape.scale = size_scale 
	
func startTimer() : 
	pass
