# Singleton

extends Node

var can_press = true

func _ready():
	pause_mode = PAUSE_MODE_PROCESS # This script can't get paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif not get_tree().paused:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
