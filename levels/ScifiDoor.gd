extends Spatial

export(bool) var OPEN = false
var can_open : bool = true
onready var SCIFI_CLOSED = $SciFi_Corridor_Door
onready var SCIFI_OPEN = $SciFi_Corridor_Section
onready var DOOR_COLLIDER = $DoorCollider

# Called when the node enters the scene tree for the first time.
func _ready():
	if OPEN:
		open_door()
	elif not OPEN:
		close_door()

func toggle():
	if is_open():
		close_door()
	elif not is_open():
		open_door()

func open_door():
	SCIFI_CLOSED.visible = false
	SCIFI_OPEN.visible = true
	DOOR_COLLIDER.disabled = true

func close_door():
	SCIFI_CLOSED.visible = true
	SCIFI_OPEN.visible = false
	DOOR_COLLIDER.disabled = false

func is_open():
	assert(
		not SCIFI_CLOSED.visible and SCIFI_OPEN.visible and DOOR_COLLIDER.disabled || 
		SCIFI_CLOSED.visible and not SCIFI_OPEN.visible and not DOOR_COLLIDER.disabled, 
		'ERROR: Doors neither open nor closed!'
	)
	if not SCIFI_CLOSED.visible and SCIFI_OPEN.visible and DOOR_COLLIDER.disabled:
		return true
	elif SCIFI_CLOSED.visible and not SCIFI_OPEN.visible and not DOOR_COLLIDER.disabled:
		return false
