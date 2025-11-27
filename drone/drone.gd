extends RigidBody3D

@export var motor_power = 2.5*4 * 100
@export var controller: Control

var motors: Array[Node3D] = []

var roll_pid: PID
const roll_speed = 4

var pitch_pid: PID
const pitch_speed = 4

var yaw_pid: PID
const yaw_speed = 5

const min_trottle = 0.05

func _ready() -> void:
	motors.append($Body/RT)
	motors.append($Body/LT)
	motors.append($Body/LB)
	motors.append($Body/RB)
	roll_pid = PID.new(0.003, 0.01, 0)
	pitch_pid = PID.new(-0.003, 0, 0)
	yaw_pid = PID.new(1, 0, 0)

func _apply_random_impulse(delta: float) -> void:
	var location = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
	var impulse = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	apply_impulse(impulse * linear_velocity.length() / 10 * delta, location / 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_apply_random_impulse(delta)
	
	# var forward_direction = transform.basis.x
	# var right_direction = transform.basis.z
	var up_direction = transform.basis.y
	var throttle = (controller.throttle + 1) * (1-min_trottle) / 2.0 + min_trottle

	# apply_torque(forward_direction * controller.pitch * 10)
	# apply_torque(right_direction * controller.roll * 10)
	
	var orth = transform.basis.orthonormalized().inverse()
	
	var ang_v = orth * angular_velocity

	var roll_error = roll_speed * controller.roll - ang_v.z
	var roll_correction = roll_pid.new_error(roll_error, delta)
	
	var pitch_error = pitch_speed * controller.pitch - ang_v.x
	var pitch_correction = pitch_pid.new_error(pitch_error, delta)
	
	var yaw_error = yaw_speed * controller.yaw - ang_v.y
	var yaw_correction = yaw_pid.new_error(yaw_error, delta)
	
	if cnt % 400 == 0:
		print("throttle: %s" % throttle)
		print("roll error: %s" % roll_error)
		print("roll correction: %s" % roll_correction)
		print(transform.basis.orthonormalized())
		print("ang_vel: %s" % angular_velocity)
		print("basis * ang_vel: %s" % (transform.basis.orthonormalized() * angular_velocity))

	apply_torque(up_direction * yaw_correction * motor_power * delta * 4)
	apply_motor_force(throttle + pitch_correction + roll_correction, delta, motors[0])
	apply_motor_force(throttle + pitch_correction - roll_correction, delta, motors[1])
	apply_motor_force(throttle + - pitch_correction - roll_correction, delta, motors[2])
	apply_motor_force(throttle - pitch_correction + roll_correction, delta, motors[3])

	# apply_central_force(up_direction * motor_power * 4 * throttle * delta)
	# apply_motor_force(throttle, delta, motors[0])
	# apply_motor_force(throttle, delta, motors[1])
	# apply_motor_force(throttle, delta, motors[2])
	# apply_motor_force(throttle, delta, motors[3])


var cnt = 0

func apply_motor_force(force: float, delta: float, motor_node: Node3D) -> void:
	force = min(1, max(0.03, force))
	
	# force *= 1+(randf() * 2 - 1)/40
	
	var up_direction = transform.basis.y
	var force_v3 = force * delta * up_direction * motor_power
	cnt += 1
	if cnt % 400 == 0:
		cnt += 1
		#print("applying force: %s" % force_v3)
	apply_force(force_v3, transform.basis.orthonormalized() * motor_node.position)
	if motor_node.get_meta("cw"):
		motor_node.rotate_y(force ** 0.3 * delta * 60)
	else:
		motor_node.rotate_y(-force ** 0.3 * delta * 60)
