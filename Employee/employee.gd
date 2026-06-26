extends CharacterBody2D

enum State {
	IDLE,
	MOVING,
	WORKING,
	DRAGGING
}

var wage_expectancy: float
var working_speed: float = 80.0
var corruption: float
var satisfaction: float

var employee_type: EmployeeTypes.EmployeeType
var state: State = State.IDLE
var employee_name: String

var current_zone: Node
var target_station: WorkStation


# -----------------------
# SETUP
# -----------------------
func setup(_current_zone):
	current_zone = _current_zone
	employee_type = current_zone.tier_type
	global_position = current_zone.default_position


func _ready():
	pass


# -----------------------
# MAIN LOOP
# -----------------------
func _physics_process(delta: float) -> void:
	if state == State.DRAGGING:
		_handle_drag()
		move_and_slide()
		return
	_run_ai(delta)
	move_and_slide()
	print(state)

func _run_ai(delta: float) -> void:
	match employee_type:
		EmployeeTypes.EmployeeType.FARMER:
			_farmer_ai(delta)
		EmployeeTypes.EmployeeType.WORKER:
			pass
		EmployeeTypes.EmployeeType.MANAGER:
			pass


# -----------------------
# FARMER AI
# -----------------------
func _farmer_ai(delta: float) -> void:
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			_find_station()
			if target_station:
				state = State.MOVING
		State.MOVING:
			if not is_instance_valid(target_station):
				_reset_to_idle()
				return
			_move_to_station(target_station)
		State.WORKING:
			if not is_instance_valid(target_station):
				_reset_to_idle()
				return
			target_station.work(delta)


func _reset_to_idle():
	target_station = null
	state = State.IDLE


# -----------------------
# MOVEMENT
# -----------------------
func _move_to_station(station: WorkStation) -> void:
	var dx = station.global_position.x - global_position.x

	# ARRIVED
	if abs(dx) <= 5:
		velocity = Vector2.ZERO
		state = State.WORKING

		if not station.is_busy:
			station.is_busy = true
			target_station = station

		return

	# MOVING
	_move_towards_x(dx)


func _move_towards_x(dx: float) -> void:
	velocity.x = sign(dx) * working_speed
	velocity.y = 0


# -----------------------
# STATION SELECTION
# -----------------------
func _find_station() -> void:
	if current_zone == null:
		return
	var best: WorkStation = null
	var best_dist := INF
	for child in current_zone.get_children():
		if child is WorkStation and not child.is_busy:
			var d = global_position.distance_to(child.global_position)
			if d < best_dist:
				best_dist = d
				best = child
	target_station = best


# -----------------------
# DRAG SYSTEM
# -----------------------
func start_drag():
	if DragManager.dragged_employee != null:
		return
	DragManager.dragged_employee = self
	state = State.DRAGGING


func stop_drag():
	if DragManager.dragged_employee == self:
		DragManager.dragged_employee = null

	state = State.IDLE

	var zone = _get_zone_under_mouse()
	if zone:
		_apply_zone(zone)
	else:
		global_position = current_zone.default_position

	target_station = null


func _handle_drag():
	velocity = Vector2.ZERO
	global_position = get_global_mouse_position() + Vector2(0, 8)
	if target_station != null:
		target_station.is_busy = false
		target_station = null


# -----------------------
# ZONE LOGIC
# -----------------------
func _apply_zone(zone: Area2D):
	employee_type = zone.tier_type
	current_zone = zone
	global_position.y = zone.default_position.y


func _get_zone_under_mouse() -> Area2D:
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results = get_world_2d().direct_space_state.intersect_point(query)

	for r in results:
		var obj = r.collider
		if obj is Area2D and obj.is_in_group("employee_zone"):
			return obj

	return null


# -----------------------
# INPUT
# -----------------------
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if DragManager.dragged_employee and DragManager.dragged_employee != self:
			return
		if event.pressed:
			start_drag()
		else:
			stop_drag()
