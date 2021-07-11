extends RigidBody2D

onready var pickUpArea = $PickUpArea
onready var collision = $PhysicsCollision
export var guestName = "Dieter"
export var  PICKUPTRESHOLD = 100
export var destinationColor = Color.white
var pickup_time

signal picked_up(color,name)
signal dropped_off_success 
signal dropped_off_idle
signal dropped_off_fail

var rng = RandomNumberGenerator.new()
onready var exclusionZoneShape = $ExclusionZone/CollisionShape2D
var sprite

var delivered

enum states {
	waiting,
	tethered,
	delivered
}
var colorList = [
	Color.yellow,
	Color.violet,
	Color.red,
	Color.blue
]
var names = [
	'Dieter',
	'Peter',
	'Gabi',
	'Ursula',
	'Manni',
	'Karl',
	'Christa',
	'Britta'
]
var currentState = states.waiting

var follow_node = null
var follow_guest = null
var follow_pos = global_position

func set_state(state):
	if state == states.delivered:
		pickUpArea.monitorable = false
		pickUpArea.monitoring = false
		collision.disabled = true
	if state == states.waiting:
		collision.disabled = false
		mode = RigidBody2D.MODE_KINEMATIC
	if state == states.tethered:
		collision.disabled = false
		mode = RigidBody2D.MODE_STATIC

func _physics_process(delta):
	if currentState == states.waiting:
		linear_velocity.move_toward(Vector2.ZERO,5.0)
		collision.disabled = false
	elif currentState == states.tethered:
		var rot_dir = get_angle_to(follow_pos)
		rotation += (rot_dir + deg2rad(90))*0.2
		var distance = follow_pos.distance_to(global_position)
		global_position = follow_pos
		pass


func _process(delta):
	if delivered != null and OS.get_system_time_msecs() - delivered > 1000:
		queue_free()
	if visible == false:
		follow_node = self
		if delivered == null:
			delivered = OS.get_system_time_msecs()
		currentState = states.delivered
	if follow_node != null and follow_node != self:
		currentState = follow_node.currentState
		if follow_node.visible == false:
			follow_node = self
		if follow_node == self:
			currentState = states.waiting
		else:
			currentState = states.tethered
			follow_pos = follow_node.get_node("Anchor/Joint/Rope/Anchor").global_position
	else:
		currentState = states.waiting
		follow_pos = global_position

func _ready():
	rng.randomize()
	choose_random_sprite()
	assign_color()
	assign_name()

func assign_name():
	guestName = names[rng.randi_range(0,names.size()-1)]

func assign_color():
	destinationColor = colorList[rng.randi_range(0,colorList.size()-1)]
	sprite.modulate = destinationColor
	
func _on_PickUpArea_body_entered(body):
	print(body.name)
	if body.name == "Playa":
		pickup_time = OS.get_system_time_msecs()
		emit_signal("picked_up",destinationColor,guestName)

func _on_PickUpArea_area_entered(area):
	if area.name == "DROPOFF":
		if area.destinationColor == destinationColor:
			emit_signal("dropped_off_success")
		else:
			emit_signal("dropped_off_fail")
	

func choose_random_sprite():
	var spriteNum = rng.randi_range(0,100)
	if spriteNum % 2 == 0:
		$SpriteMarkus.visible = true
		sprite = $SpriteMarkus
	if spriteNum % 2 != 0:
		$SpriteSam.visible = true
		sprite = $SpriteSam	