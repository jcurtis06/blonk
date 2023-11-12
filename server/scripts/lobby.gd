extends Node

func announce(message: String) -> void:
	send_announcement.rpc(message)

@rpc("any_peer", "call_local")
func send_announcement(message: String) -> void:
	print("[SERVER]: " + message)
