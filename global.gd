extends Node

var Player : KinematicBody
var Alien : KinematicBody
var vents : Array

func set_player(new_player : KinematicBody):
	if not new_player == null:
		Player = new_player
		return true
	else:
		print("Error: player not set!")
		return false

func get_player() -> KinematicBody:
	if not Player == null:
		return Player
	else:
		print("Error: player is null!")
		return null

func set_alien(new_alien : KinematicBody):
	if not new_alien == null:
		Alien = new_alien
		return true
	else:
		print("Error: alien not set!")
		return false

func get_alien() -> KinematicBody:
	if not Alien == null:
		return Alien
	else:
		print("Error: alien is null!")
		return null

func add_vent(new_vent : Spatial):
	vents.append(new_vent)
	if new_vent in vents:
		return true
	else:
		print("Error: vent not added!")
		return false

func get_vents() -> Array:
	return vents

func remove_vent(new_vent : Spatial):
	vents.remove(vents.find(new_vent))
	if not new_vent in vents:
		return true
	else:
		print("Error: vent not removed!")
		return false
