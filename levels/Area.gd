extends Area

func interact():
	if not get_parent() == null:
		 get_parent().toggle()
