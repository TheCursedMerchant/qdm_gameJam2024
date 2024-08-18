extends Node

var textures : Array

func _ready() -> void:
	textures.append(preload("res://assets/art/fat_fish.png"))
	textures.append(preload("res://assets/art/fat_fish_green.png"))
	textures.append(preload("res://assets/art/torpedo_fish.png"))
	textures.append(preload("res://assets/art/torpedo_fish_green.png"))

func get_random_texture() -> Texture2D : 
	return textures[randi_range(0, textures.size() - 1)]
