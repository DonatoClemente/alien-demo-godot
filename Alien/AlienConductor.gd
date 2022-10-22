extends Spatial

var MENACE_RESET_VAL = 50
var menace = 50

onready var alien = $Alien
onready var timer = $Timer
onready var navigation = get_parent()

func _ready():
	timer.start()

func _physics_process(_delta):
	check_menace()

func check_menace():
	# Initiate Active Phase
	
	# Leave Active Phase
	
	pass

func _on_Timer_timeout():
	# Give alien current player pos
	
	pass
