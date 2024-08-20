extends Node
class_name SpawnGroup

var spawners : Array

func _ready() -> void:
	spawners = get_children()
	
func activateGroup() : 
	for spawner in spawners: 
		spawner.isActive = true
		
func deactivateGroup() : 
	for spawner in spawners: 
		spawner.isActive = false
