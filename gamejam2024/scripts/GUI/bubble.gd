extends Sprite2D

@onready var toggleTimer : Timer = $Toggle

var speed := 100
var direction := Vector2.UP
var startPositon := Vector2.ZERO
var xSpeed := 1

func _ready() -> void: 
	toggleTimer.connect("timeout", on_toggle_timeout)
	toggleTimer.start(randf_range(0, 1.0))
	texture = GameRes.get_random_bubble_texture()
	startPositon = global_position
	z_index = -100
	self_modulate.a = .5

func _process(delta: float) -> void:
	global_position += direction * speed * delta
	global_position.x += xSpeed
	
	if(global_position.y <= -128) :
		global_position = Vector2(randf_range(25, get_viewport_rect().size.x - 25), startPositon.y) 
		texture = GameRes.get_random_bubble_texture()
		
func on_toggle_timeout() : 
	xSpeed = -xSpeed
