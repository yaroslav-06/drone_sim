extends Control

@export var throttle: float = -1
@export var yaw: float = 0
@export var pitch: float = 0
@export var roll: float = 0
@export var controller_sencitivity: float = 0.016
@export var joystick_enabled = true

var throttle_slider: VSlider
var yaw_slider: VSlider

const dead_zone = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	throttle_slider = $Throttle/VSlider
	yaw_slider = $Yaw/VSlider

func set_controls(throttle_val: float, yaw_val: float, pitch_val: float, roll_val: float):
	print("throttle %f" % throttle_val)
	throttle = max(-1, min(1, throttle_val))
	throttle_slider.value = throttle

	yaw = max(-1, min(1, yaw_val))
	yaw_slider.value = yaw

	pitch = max(-1, min(1, pitch_val))

	roll = max(-1, min(1, roll_val))

func drift_back(value: float) -> float:
	if value == 0:
		return 0
	return min(controller_sencitivity / 2, abs(value)) * abs(value) / value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var throttle_val: float = -1
	var yaw_val: float = 0
	var pitch_val: float = 0
	var roll_val: float = 0
	if Input.is_action_pressed("throttle_up"):
		throttle_val = Input.get_action_strength("throttle_up")
	if Input.is_action_pressed("throttle_down"):
		throttle_val = -Input.get_action_strength("throttle_down")

	if Input.is_action_pressed("yaw_ccw"):
		yaw_val = Input.get_action_strength("yaw_ccw")
	if Input.is_action_pressed("yaw_cw"):
		yaw_val = -Input.get_action_strength("yaw_cw")

	if Input.is_action_pressed("roll_left"):
		roll_val = Input.get_action_strength("roll_left")
	if Input.is_action_pressed("roll_right"):
		roll_val = -Input.get_action_strength("roll_right")

	if Input.is_action_pressed("pitch_down"):
		pitch_val = -Input.get_action_strength("pitch_down")
	if Input.is_action_pressed("pitch_up"):
		pitch_val = Input.get_action_strength("pitch_up")

	if joystick_enabled:
		set_controls(throttle_val, yaw_val, pitch_val, roll_val)

	return
		
	throttle -= drift_back(throttle)
	
	if Input.is_action_pressed("yaw_ccw"):
		yaw += controller_sencitivity
	if Input.is_action_pressed("yaw_cw"):
		yaw -= controller_sencitivity
	
	yaw -= drift_back(yaw)

	set_controls(throttle, yaw, 0, 0)


func _on_phone_controller_set_controls(thr_val: float, yaw_val: float, pitch_val: float, roll_val: float) -> void:
	set_controls(thr_val, yaw_val, pitch_val, roll_val)
