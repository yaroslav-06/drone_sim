class_name PID

var Ki:float = 0
var Kp:float = 0
var Kd:float = 0
var initTime: float

func _init(kP: float, kI: float, kD: float):
	Ki = kI
	Kp = kP
	Kd = kD
	initTime = Time.get_unix_time_from_system()
	

var e_sum = 0
var pe = INF
var c_time = 0

func new_error(e: float, delta: float) -> float:
	var dx = 0.0
	
	#P_roportional
	var px = Kp * e
	dx += px
	
	#I_ntegral
	e_sum += e * delta
	var ix = Ki * e_sum
	dx += ix
	
	#D_erivative
	if pe != INF:
		var de = (e - pe) / delta
		var id = Kd * de
		dx += id
	pe = e
	
	return dx
