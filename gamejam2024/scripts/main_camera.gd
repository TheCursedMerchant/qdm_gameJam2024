extends Camera2D
class_name MainCamera

@export var randomStrength: float = 20.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shakeStrength: float = 0.0

const maxZoom = Vector2(1.5, 1.5)

func _ready() -> void:
	global_position = get_viewport_rect().size / 2
	
func _process(delta: float) -> void: 
	if shakeStrength > 0 : 
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		offset = randomOffset()
	
func updateZoom(amount: Vector2) :
	zoom.x = min(zoom.x + amount.x, maxZoom.x)
	zoom.y = min(zoom.y + amount.y, maxZoom.y)

func resetZoom() : 
	zoom = Vector2.ONE
	
func apply_shake() :
	shakeStrength = randomStrength
	
func randomOffset() -> Vector2 : 
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
	
