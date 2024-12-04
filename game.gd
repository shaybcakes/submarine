extends Node3D

var gas = false
var brake = false
var ang_vel:Vector3 = Vector3.ZERO
@onready var sub = $Submarine
var yaw_rot = 0
var pitch_rot = 0
var roll_rot = 0
var rings_list = []

@onready var sub_space = [$Submarine.position,$Submarine.rotation]

var elapsed:int = 0

@onready var subcast:RayCast3D = $Submarine/RayCast3D
@onready var subtime:Label3D = $Submarine/CamNode/Camera3D/MeshInstance3D3/Time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ring in $rings.get_children():
		rings_list.append(ring)
		ring.hide()
	rings_list[0].show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if subtime.get_text() == "Test" and $Timer.is_stopped():
		subtime.set_text("Hit Green Ring\nTo Start")
	elif not $Timer.is_stopped():
		subtime.set_text(str(elapsed)+"s")
		
	if subcast.is_colliding():
		if subcast.get_collider() == rings_list[0]:
			print(len(rings_list))
			if len(rings_list) == 10:
				elapsed = 0
				$Timer.start()
			rings_list[0].hide()
			rings_list.pop_front()
			rings_list[0].show()
			if len(rings_list) == 0:
				$Timer.stop()
		
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
	sub.rotate_object_local(Vector3(1,0,0),pitch_rot*0.005)
	sub.rotate_object_local(Vector3(0,1,0),yaw_rot*0.005)
	sub.rotate_object_local(Vector3(0,0,1),roll_rot*0.002)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		$Submarine.set_linear_velocity(Vector3(0,0,0))
		$Submarine.position = sub_space[0]
		$Submarine.rotation = sub_space[1]
		rings_list = []
		for ring in $rings.get_children():
			rings_list.append(ring)
			ring.hide()
		rings_list[0].show()
		$Timer.stop()
		subtime.set_text("Hit Green Ring\nTo Start")

func _on_timer_timeout() -> void:
	elapsed += 1
