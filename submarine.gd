extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gas = false
var brake = false
var ang_vel:Vector3 = Vector3.ZERO

var yaw_rot = 0
var pitch_rot = 0
var roll_rot = 0

var prop_damp = 0.0005
var prop_max = 0.1
var prop_min = -0.1

@onready var prop = $"submarine no prop/prop"
@export var prop_rot = 0
var prop_delta = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var noderot = get_rotation()
	$Camera3D/MeshInstance3D3/Label3D.set_text("x:"+str(snapped(noderot.x,0.001)) + "\ny:" + str(snapped(noderot.y,0.001))+"\nz:"+str(snapped(noderot.z,0.001)))
	prop_delta = 0
	
	var throt_axis = Input.get_axis("reverse","forward")
	if throt_axis != 0:
		prop_delta = throt_axis
		prop_max = abs(throt_axis) * 0.1
		prop_min = abs(throt_axis) * -0.1
	
	prop_rot += prop_delta*0.001
	
	prop_rot = clamp(prop_rot,prop_min,prop_max)
	
	prop.rotate_object_local(Vector3(0,0,1),prop_rot)
	
	if not (Input.is_action_pressed("forward") or Input.is_action_pressed("reverse")):
		if prop_rot != 0:
			if prop_rot > 0.001:
				prop_rot -= prop_damp
			elif prop_rot < -0.001:
				prop_rot += prop_damp
			else:
				prop_rot = 0
	
	
	var direction:Vector3 = get_rotation().normalized()
	if direction:
		velocity.x = direction.x * prop_rot * 20
		velocity.z = direction.z * prop_rot * 20
		velocity.y = direction.y * prop_rot * 20
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

func _process(delta: float) -> void:
	pass

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		gas = true
	elif event is InputEventMouseButton and event.is_released():
		gas = false


func _on_area_3d_input_event_brake(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		brake = true
	elif event is InputEventMouseButton and event.is_released():
		brake = false
