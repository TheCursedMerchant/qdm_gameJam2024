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

func resetDisplayParams() : 
	score = 0
	stomachSize = 0
	stomachCapacity = 1

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
	
const HIT_SHAKE_DURATION := 0.5
const HIT_SHAKE_FREQUENCY := 6.0
const HIT_SHAKE_AMPLITUDE := 3

var masterVolume = 0.75
