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
var hunterCap = 1
var pufferCap = 2
var activeHunters = 0
var activePuffers = 0
var difficultyModifier := 0.0
var difficultyPeriod := 1.0

func canSpawnHunter() -> bool : 
	return (difficultyModifier > 3.0) and (activeHunters < hunterCap)
	
func canSpawnPuffer() -> bool : 
	return (difficultyModifier > 5.0) and (activePuffers < hunterCap)

func resetDisplayParams() : 
	score = 0
	stomachSize = 0
	activeHunters = 0
	activePuffers = 0
	difficultyModifier = 0
	stomachCapacity = 1

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
	
const HIT_SHAKE_DURATION := 0.5
const HIT_SHAKE_FREQUENCY := 6.0
const HIT_SHAKE_AMPLITUDE := 3

# Settings
var masterVolume = 0.75

var hunterTime = 10
