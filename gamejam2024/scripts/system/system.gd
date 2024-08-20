extends Node

enum PLAYER_STATES {
	IDLE,
	CHARGE,
	DASH,
	DEAD
}

# Display Params 
var score = 0
var player_level = 0
var player_xp = 0
var remaining_xp = 0
var evolve_xp = 50
var stomachSize = 0
var stomachCapacity = 1
var player_body : CharacterBody2D

# Spawn Config
var huntersSpawnable = false
var puffersSpawnable = false
var difficultyModifier := 0.0
var difficultyPeriod := 10.0

func resetDisplayParams() : 
	score = 0
	stomachSize = 0
	difficultyModifier = 0
	stomachCapacity = 1
	huntersSpawnable = false
	puffersSpawnable = false

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
	
const HIT_SHAKE_DURATION := 0.5
const HIT_SHAKE_FREQUENCY := 6.0
const HIT_SHAKE_AMPLITUDE := 3

# Settings
var masterVolume = 0.75

var hunterTime = 10
