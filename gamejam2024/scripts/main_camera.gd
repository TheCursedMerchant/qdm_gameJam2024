extends Camera2D

func _ready() -> void:
	global_position = get_viewport_rect().size / 2
	
func updateZoom(amount: Vector2) :
	zoom += amount

func resetZoom() : 
	zoom = Vector2.ONE
