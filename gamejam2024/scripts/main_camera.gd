extends Camera2D

const maxZoom = Vector2(1.5, 1.5)

func _ready() -> void:
	global_position = get_viewport_rect().size / 2
	
func updateZoom(amount: Vector2) :
	zoom.x = min(zoom.x + amount.x, maxZoom.x)
	zoom.y = min(zoom.y + amount.y, maxZoom.y)

func resetZoom() : 
	zoom = Vector2.ONE
