extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_angular_damp(0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_angular_velocity().z)
	if Input.is_action_just_pressed("forward") or Input.is_action_just_pressed("reverse"):
		set_angular_damp(0.1)
	elif (Input.is_action_just_released("forward") and not Input.is_action_pressed("reverse") ) or (Input.is_action_just_released("reverse") and not Input.is_action_pressed("forward")):
		set_angular_damp(0.3)
	if Input.is_action_pressed("forward"):
		apply_torque(Vector3(0,0,-1))
	if Input.is_action_pressed("reverse"):
		apply_torque(Vector3(0,0,1))
	var ang_vel_z = get_angular_velocity().z
	#print(get_angular_velocity().z)
	if get_angular_velocity().z > 10:
		set_angular_velocity(Vector3(0,0,10))
	elif get_angular_velocity().z < -10:
		set_angular_velocity(Vector3(0,0,-10))
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == 87 and event.pressed == true:
			pass
		elif event.keycode == 87 and event.pressed == false:
			pass
		elif event.keycode == 83 and event.pressed ==true:
			pass
		elif event.keycode == 83 and event.pressed == false:
			pass
