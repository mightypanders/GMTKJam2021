extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var anchor_ahead

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = RigidBody2D.MODE_STATIC
	pass # Replace with function body.


func start():
	mode = RigidBody2D.MODE_KINEMATIC

func _physics_process(delta):
	if mode == RigidBody2D.MODE_STATIC:
		if anchor_ahead != null:
			var rot_dir = get_angle_to(anchor_ahead.global_position)
			rotation += (rot_dir)
			global_position = (anchor_ahead.global_position + Vector2(10,0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode == RigidBody2D.MODE_STATIC:
		if anchor_ahead != null:
			var rot_dir = get_angle_to(anchor_ahead.global_position)
			rotation += (rot_dir)
			global_position = (anchor_ahead.global_position + Vector2(10,0))
	pass
