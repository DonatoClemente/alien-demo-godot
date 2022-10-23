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
var is_backstage = false
var going_backstage = false
var going_active = false

onready var collider = $CollisionShape
onready var agent: NavigationAgent = $NavigationAgent
onready var timer: Timer = $Timer
onready var mesh: MeshInstance = $MeshInstance
onready var nav: Navigation = get_parent()

func _ready():
	to_backstage_noclip()

func _physics_process(_delta):
	if POIs.size() > 0:
		agent.set_target_location(POIs.front())
	if agent.is_navigation_finished():
		POIs.pop_front()
		return
	var dir = global_transform.origin.direction_to(agent.get_next_location())
	move_and_slide(dir * current_speed, Vector3.UP)

func to_active() -> void:
	# play animation & enable collidercurrent_speed = RUN_SPEED
	if not going_active:
		going_active = true
		clear_and_add_POI([get_pos(get_nearest_vent())])
		current_state = STATES.flee
		yield($NavigationAgent, "navigation_finished")
		collider.disabled = false
		mesh.visible = true
		is_backstage = false
		current_speed = WALK_SPEED
		current_state = STATES.search
		generate_POIs()
		going_active = false
		print("active")

func to_backstage() -> void:
	# disable collider & lock to top of map pos
	if not going_backstage:
		going_backstage = true
		current_speed = RUN_SPEED
		clear_and_add_POI([get_pos(get_nearest_vent())])
		current_state = STATES.flee
		yield($NavigationAgent, "navigation_finished")
		collider.disabled = true
		mesh.visible = false
		is_backstage = true
		current_state = STATES.search
		going_backstage = false
		print("backstage")

func to_backstage_noclip() -> void:
	collider.disabled = true
	mesh.visible = false
	is_backstage = true
	current_state = STATES.search
	print("backstage_noclip")

func _on_Timer_timeout():
	if current_state == STATES.flee:
		clear_and_add_POI([get_pos(get_nearest_vent())])
	if not is_backstage:
		menace -= 1
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(get_pos(self),get_pos(Global.Player),[self])
		if Global.get_player() == result.collider:
			menace -= 1
		if menace <= -100 and not going_backstage:
			to_backstage()
	else:
		menace += 1
		if menace >= 50 and not going_active:
			to_active()
	timer.start()

func generate_POIs() -> void:
	# get target and generate POIs in a radius around target
	print("generate POIs called")
	if nav != null:
		var arr = []
		for n in range(3):
			var point_on_nav = nav.get_closest_point(Vector3(rand_range(-50, 50), 0, rand_range(-50, 50)))
			arr.insert(0,point_on_nav)
		clear_and_add_POI(arr)
	else:
		print("Error: No nav!")

func get_nearest_vent() -> Spatial:
	var vents = Global.vents
	var closest = vents.front()
	var position : Vector3 = get_pos(self)
	for vent in vents:
		if position.distance_to(get_pos(vent)) < position.distance_to(get_pos(closest)):
			closest = vent
	return closest

func get_pos(object) -> Vector3:
	return object.global_transform.origin

func clear_and_add_POI(pois : Array) -> void:
	POIs.clear()
	for poi in pois:
		POIs.append(poi)
