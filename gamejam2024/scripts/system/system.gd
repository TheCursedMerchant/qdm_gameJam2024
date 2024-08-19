extends Node

enum PLAYER_STATES {
	IDLE,
	CHARGE,
	DASH,
	DEAD
}

var score = 0
var player_level = 0
var player_xp = 0
var remaining_xp = 0
var evolve_xp = 50
var player_body : CharacterBody2D

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
	
const HIT_SHAKE_DURATION := 0.5
const HIT_SHAKE_FREQUENCY := 6.0
const HIT_SHAKE_AMPLITUDE := 3

var masterVolume = 0.75
