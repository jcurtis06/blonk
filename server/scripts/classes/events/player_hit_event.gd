extends Event
class_name PlayerDamageEvent

var attacker: PlayerData
var target: PlayerData
var damage: int

func execute():
	target.health -= damage
	has_executed = true

func cancel():
	if has_executed:
		target.health += damage
