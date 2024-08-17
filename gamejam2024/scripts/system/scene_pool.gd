class_name ScenePool
extends Node

var pool : Array = []
var poolSize : int
var lastSceneIndex : int = 0

func _init(_poolSize : int) -> void:
	poolSize = _poolSize
	
func addAtPosition(_pos : Vector2, createScene: Callable) :
	if pool.size() < poolSize : 
		var newScene = createScene.call()
		pool.append(newScene)
		newScene.global_position = _pos
	else : 
		var availableScene = pool[lastSceneIndex]
		availableScene.global_position = _pos
		
		if(availableScene.has_method("reactivate")) : 
			availableScene.reactivate()
			
		lastSceneIndex += 1
		if lastSceneIndex >= poolSize : 
			lastSceneIndex = 0
			
func getLastScene() : 
	return pool[lastSceneIndex]
