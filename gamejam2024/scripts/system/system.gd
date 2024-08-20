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
var hunterCap = 0
var pufferCap = 0
var activeHunters = 0
var activePuffers = 0
var difficultyModifier := 0.0
var difficultyPeriod := 12.0

func canSpawnHunter() -> bool : 
	return (difficultyModifier > 3.0) and (activeHunters < hunterCap)
	
func canSpawnPuffer() -> bool : 
	return (difficultyModifier > 5.0) and (activePuffers < pufferCap)

func resetDisplayParams() : 
	score = 0
	stomachSize = 0
	activeHunters = 0
	activePuffers = 0
	difficultyModifier = 0
	stomachCapacity = 1
	hunterCap = 0
	pufferCap = 0

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
	
const HIT_SHAKE_DURATION := 0.5
const HIT_SHAKE_FREQUENCY := 6.0
const HIT_SHAKE_AMPLITUDE := 3

# Settings
var masterVolume = 0.75

var hunterTime = 10
