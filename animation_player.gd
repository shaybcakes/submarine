extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("prop_forward")
	pause()
	set_speed_scale(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
	#print(event)
	#if event is InputEventKey:
		#if event.keycode == 87 and event.pressed == true:
			#play()
		#elif event.keycode == 87 and event.pressed == false:
			#pause()
		#elif event.keycode == 83 and event.pressed ==true:
			#play_backwards()
		#elif event.keycode == 83 and event.pressed == false:
			#pause()
