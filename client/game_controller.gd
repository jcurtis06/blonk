# Game Controller handles communications between the server.
#
# This is auto-loaded and ONLY controls rounds, NOT joining lobbies.
extends Node

signal on_countdown_started
signal on_round_started
signal on_round_ended

@export var remaining_time := 0.0

var state := GameState.LOBBY

# ----------------
# HELPER FUNCTIONS
# ----------------

func get_hiders() -> Array[int]:
	return []

# -------------
# RPC FUNCTIONS
# -------------

@rpc("authority")
func countdown_started() -> void:
	state = GameState.COUNTDOWN
	on_countdown_started.emit()

@rpc("authority")
func round_started() -> void:
	state = GameState.IN_GAME
	on_round_started.emit()

@rpc("authority")
func round_ended() -> void:
	state = GameState.END
	on_round_ended.emit()

@rpc("any_peer")
func request_start_round(from_id: int, countdown: int = 5, round_time: float = 60.0) -> void:
	print("Starting Round")

@rpc("any_peer")
func player_dead(id: int) -> void:
	print("Player " + str(id) + " has died!")
