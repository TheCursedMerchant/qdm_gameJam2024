extends Area2D
class_name PufferStinger

@onready var lifespan = $LifespanTimer
@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D

@export var projectile_speed = 100.00
var direction := Vector2.RIGHT
var isActive := true
var size_scale := Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateScale(size_scale)
	lifespan.connect("timeout", on_lifetime_timeout)
	lifespan.start(5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (isActive) : 
		global_position += direction * projectile_speed * delta

func on_lifetime_timeout():
	isActive=false

func reactivate():
	isActive = true
	lifespan.start(2)

func _on_area_entered(area: Area2D) -> void :
	if(area.is_in_group("Player")) :
		area.take_damage()
		
func updateScale(_scale : Vector2) :
	size_scale = _scale * 2
	sprite.scale = size_scale
	collisionShape.scale = size_scale
