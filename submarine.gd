extends RigidBody3D


@export var SPEED = 20
@export var YSPEED = 10
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

@onready var cam_pos_src = [$CamNode.position,$CamNode.rotation]

func _ready() -> void:
	set_linear_damp(1)

func _physics_process(delta: float) -> void:
	var noderot = get_rotation()
	$CamNode/Camera3D/MeshInstance3D3/Label3D.set_text("x:"+str(snapped(noderot.x,0.001)) + "\ny:" + str(snapped(noderot.y,0.001))+"\nz:"+str(snapped(noderot.z,0.001)))
	prop_delta = 0
	
	#rotate propeller based on throttle axis
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
	
	$CamNode/Camera3D/MeshInstance3D3/Label3D2.set_text(str(position))
	
	if prop_rot != 0:
		apply_central_force(transform.basis.z *prop_rot*SPEED)
		
	var trans_y = Input.get_axis("trans_down","trans_up")
	if trans_y != 0:
		apply_central_force(transform.basis.y * trans_y * YSPEED)


func _process(delta: float) -> void:
	$CamNode.rotation_degrees.y = Input.get_axis("camera_left","camera_right")*100
	$CamNode.rotation_degrees.x = Input.get_axis("camera_down","camera_up")*-100
	
	#adjust camera based on speed
	var tubing = 10
	if prop_rot != 0:
		$CamNode.position.z = cam_pos_src[0].z - prop_rot * 10
		$CamNode.position.y = cam_pos_src[0].y - prop_rot * 10
		$CamNode.rotation.x = cam_pos_src[1].x - prop_rot
	else:
		$CamNode.position = cam_pos_src[0]
		

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

func _input(event: InputEvent) -> void:
	pass
