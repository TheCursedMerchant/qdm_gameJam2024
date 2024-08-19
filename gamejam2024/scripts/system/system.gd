extends Node

enum PLAYER_STATES {
	IDLE,
	CHARGE,
	DASH,
	DEAD
}

var score = 0
var player_level = 2
var player_xp = 0
var remaining_xp = 0
var evolve_xp = 50

func getRemainingXp() -> int : 
	return evolve_xp - player_xp
