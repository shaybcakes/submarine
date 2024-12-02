extends Node3D

var gas = false
var brake = false
var ang_vel:Vector3 = Vector3.ZERO
@onready var sub = $Submarine
var yaw_rot = 0
var pitch_rot = 0
var roll_rot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pitch_rot = 0
	yaw_rot = 0
	roll_rot = 0
	var pitch_delta = Input.get_axis("pitch_up","pitch_down")
	var yaw_delta = Input.get_axis("yaw_right","yaw_left")
	var roll_delta = Input.get_axis("roll_left","roll_right")
	#$Camera3D/MeshInstance3D3/Label3D.set_text("Pitch:" + str(snapped(pitch_delta,0.01)) + "\nYaw:" + str(snapped(yaw_delta,0.01)) + "\nRoll:" + str(snapped(roll_delta,0.01)))

	var angular_delta = Vector3(pitch_delta, 0,yaw_delta)
	
	yaw_rot += yaw_delta
	pitch_rot += pitch_delta
	roll_rot += roll_delta
	
	#transform.basis = Basis()
	sub.rotate_object_local(Vector3(1,0,0),pitch_rot*0.01)
	sub.rotate_object_local(Vector3(0,1,0),yaw_rot*0.01)
	sub.rotate_object_local(Vector3(0,0,1),roll_rot*0.01)
	
