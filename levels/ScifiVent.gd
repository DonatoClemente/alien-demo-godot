extends Spatial

func _ready():
	Global.add_vent(self)


func _on_Area_body_entered(body):
	if body == Global.get_player():
		print('You woulda died...')
		Global.remove_vent(self)


func _on_Area_body_exited(body):
	if body == Global.get_player():
		yield(get_tree().create_timer(4.0),"timeout")
		Global.add_vent(self)
