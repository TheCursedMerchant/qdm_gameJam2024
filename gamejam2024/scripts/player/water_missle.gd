extends Area2D
class_name WaterMissile

@onready var lifeTimeTimer : Timer = $LifeTimeTimer
@onready var sprite : Sprite2D = $Sprite2D
@onready var collisionShape : CollisionShape2D = $CollisionShape2D

@export var speed := 1000.00

var direction := Vector2.RIGHT
var isActive := true
var size_scale := Vector2.ONE
var hitCallback : Callable

func _ready() -> void:
	updateScale(size_scale)
	lifeTimeTimer.connect("timeout", on_lifetime_timeout)
	lifeTimeTimer.start(5.0)

func _physics_process(delta: float) -> void:
	if (isActive) : 
		global_position += direction * speed * delta
		
func on_lifetime_timeout() : 
	isActive = false
		
func reactivate() : 
	isActive = true
	lifeTimeTimer.start(5.0)

func _on_area_entered(area: Area2D) -> void :
	if(area.is_in_group("Enemy") && !area.isSplit) :
		hitCallback.call()
		area.take_damage()

func updateScale(_scale : Vector2) :
	size_scale = _scale * 2
	sprite.scale = size_scale
	collisionShape.scale = size_scale
