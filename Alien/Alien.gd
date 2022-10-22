extends KinematicBody

var STATES = {'search': 'SEARCH', 'investigate': 'INVESTIGATE', 'chase': 'CHASE','flee': 'FLEE'}
var current_state = STATES.search
var points_of_interest = []
var path = []
var path_node = 0
export var WALK_SPEED = 2
export var RUN_SPEED = 7
var current_speed = WALK_SPEED

var menace = 50
var POIs = []
var target

onready var is_backstage = false
onready var collider = $CollisionShape
onready var agent: NavigationAgent = $NavigationAgent
onready var timer: Timer = $Timer
onready var mesh: MeshInstance = $MeshInstance
onready var navigation: Navigation = get_parent()

func _ready():
	#agent.set_target_location(Global.get_player().global_transform.origin)
	to_backstage_noclip()

func _physics_process(_delta):
	
	if agent.is_navigation_finished():
		POIs.pop_front()
		return
	var dir = global_transform.origin.direction_to(agent.get_next_location())
	move_and_slide(dir * current_speed, Vector3.UP)

func to_active():
	# play animation & enable collidercurrent_speed = RUN_SPEED
	POIs = []
	var nearest_vent = get_nearest_vent().global_transform.origin
	POIs.append(Vector3(nearest_vent.x, global_transform.origin.y, nearest_vent.z))
	current_state = STATES.flee
	yield($NavigationAgent, "navigation_finished")
	collider.disabled = false
	mesh.visible = true
	is_backstage = false
	current_speed = WALK_SPEED
	current_state = STATES.search
	generate_POIs()
	print("active")

func to_backstage():
	# disable collider & lock to top of map pos
	current_speed = RUN_SPEED
	POIs = []
	var nearest_vent = get_nearest_vent().global_transform.origin
	POIs.append(Vector3(nearest_vent.x, global_transform.origin.y, nearest_vent.z))
	current_state = STATES.flee
	yield($NavigationAgent, "navigation_finished")
	#yield($Timer,"timeout")
	collider.disabled = true
	mesh.visible = false
	is_backstage = true
	current_state = STATES.search
	print("backstage")

func to_backstage_noclip():
	collider.disabled = true
	mesh.visible = false
	is_backstage = true
	current_state = STATES.search
	print("backstage_noclip")

func _on_Timer_timeout():
	if current_state == STATES.flee:
		POIs = []
		var nearest_vent = get_nearest_vent().global_transform.origin
		POIs.append(Vector3(nearest_vent.x, global_transform.origin.y, nearest_vent.z))
	if POIs.size() > 0:
		agent.set_target_location(POIs.front())
	if not is_backstage:
		menace -= 1
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(global_transform.origin,Global.get_player().global_transform.origin,[self])
		if Global.get_player() == result.collider:
			menace -= 1
	else:
		menace += 1
	if not is_backstage && menace <= -100:
		to_backstage()
	elif is_backstage && menace >= 50:
		to_active()
	print(menace)
	print(global_transform.origin)
	print(POIs.front())
	timer.start()

func generate_POIs():
	# get target and generate POIs in a radius around target
	# Z -50 +50 : X 40 -50
	for i in 3:
		var x = rand_range(-50, 50)
		var z = rand_range(-50, 50)
		var point_on_nav = navigation.get_closest_point(Vector3(x, global_transform.origin.y, z))
		POIs.append(point_on_nav)
		print(x)
		print(z)
		print(point_on_nav)

func get_nearest_vent() -> Spatial:
	var vents = Global.vents
	var closest = vents.front()
	var position : Vector3 = global_transform.origin
	for vent in vents:
		if position.distance_to(vent.global_transform.origin) < position.distance_to(closest.global_transform.origin):
			closest = vent
	return closest

