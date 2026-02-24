@tool
extends EditorPlugin

const MOVE_SPEED := 5.0
const LOOK_SPEED := 0.05
const DEADZONE := 0.15

func _process(delta: float) -> void:
	var vp := get_editor_interface().get_editor_viewport_3d(0)
	if not vp:
		return
	var cam := vp.get_camera_3d()
	if not cam:
		return
	
	var t := cam.global_transform
	
	# Right stick
	var rx := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var ry := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	if abs(rx) < DEADZONE: rx = 0.0
	if abs(ry) < DEADZONE: ry = 0.0
	
	# Left stick
	var lx := Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var ly := Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	if abs(lx) < DEADZONE: lx = 0.0
	if abs(ly) < DEADZONE: ly = 0.0
	
	# Triggers
	var lt := Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)
	var rt := Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)
	if abs(lt) < DEADZONE: lt = 0.0
	if abs(rt) < DEADZONE: rt = 0.0
	
	if (abs(rx) + abs(ry) + abs(lx) + abs(ly) + abs(lt) + abs(rt)) < DEADZONE:
		return
	
	# Rotation
	t.basis = t.basis.rotated(Vector3.UP, -rx * LOOK_SPEED * 60 * delta)
	var new_basis = t.basis.rotated(t.basis.x, -ry * LOOK_SPEED * 60 * delta)
	var new_pitch = rad_to_deg(new_basis.get_euler().x)
	if new_pitch >= -85.0 and new_pitch <= 85.0:
		t.basis = new_basis
	t.basis = t.basis.orthonormalized()
	
	# Position
	t.origin += t.basis.x * lx * MOVE_SPEED * delta
	t.origin += t.basis.z * ly * MOVE_SPEED * delta
	t.origin += t.basis.y * (rt-lt) * MOVE_SPEED * delta
	
	cam.global_transform = t

func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass
