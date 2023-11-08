extends Node

var room_key = ""
var players_pending_codes: Array[int] = []

# Store the peer IDs of seekers & hiders
var seekers: PackedInt32Array = []
var hiders:PackedInt32Array = []
