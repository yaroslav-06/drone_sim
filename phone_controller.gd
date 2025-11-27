extends Node

# The URL we will connect to.
@export var websocket_url = "ws://localhost:1450/game"

# signal to call when recieved new controls from the controller
signal set_controls(thr: float, yaw: float, pitch: float, roll: float)

# Our WebSocketClient instance.
var socket = WebSocketPeer.new()

@export var action_left := "ui_left"
@export var action_right := "ui_right"
@export var action_up := "ui_up"
@export var action_down := "ui_down"

var controller_deadzone = 0.1

func _ready():
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Send data.
		socket.send_text("Test packet")

func process_controller(msg: String):
	if "heartbeat" in msg:
		socket.send_text("heartbeat")
	if msg == "arm":
		socket.send_text("armed")
	elif msg == "disarm":
		get_tree().reload_current_scene()

	var throttle: float
	var yaw: float
	var pitch: float
	var roll: float
	
	return
	
	if "controls:" in msg:
		var data = msg.substr(len("controls:")).split(",")
		throttle = float(data[0])
		yaw = -float(data[1])
		pitch = float(data[3])
		roll = -float(data[2]) 
		if abs(yaw) < controller_deadzone:
			yaw = 0
		if abs(pitch) < controller_deadzone:
			pitch = 0
		if abs(roll) < controller_deadzone:
			roll = 0
		if abs(throttle) < 0.001:
			throttle = -1
		set_controls.emit(throttle, yaw, pitch, roll)
		return
		
	print("message: %s" % msg)

func _process(_delta):
	return
	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()
	
	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var data = socket.get_packet().get_string_from_utf8()
			process_controller(data)

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.
