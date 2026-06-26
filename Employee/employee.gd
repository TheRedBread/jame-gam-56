extends CharacterBody2D

enum State {
	IDLE,
	MOVING,
	WORKING,
	INTERACTING,
	DRAGGING,
	STEALING
}

var wage_expentancy : float
var working_speed : float
var corruption : float
var satisfaction : float

var employee_type : EmployeeTypes.EmployeeType
var state : State = State.IDLE
var employee_name : String

var current_zone

var target_station: WorkStation

func setup(_current_zone):
	current_zone = _current_zone
	employee_type = current_zone.tier_type
	position = current_zone.default_position


func _ready():
	pass

func change_employee_type():
	pass

func _physics_process(delta: float) -> void:
	if state == State.DRAGGING:
		if target_station != null:
			target_station.is_busy = false
			target_station = null
		handle_drag()
		return
	do_AI(delta)
	move_and_slide()
	


func do_AI(delta):
	match employee_type:
		EmployeeTypes.EmployeeType.FARMER:
			farmer_AI(delta)
		EmployeeTypes.EmployeeType.WORKER:
			worker_AI(delta)
		EmployeeTypes.EmployeeType.MANAGER:
			manager_AI(delta)

func farmer_AI(delta):
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			find_station()
			if target_station != null:
				state = State.MOVING
		State.MOVING:
			if target_station == null:
				state = State.IDLE
				return
			move_to_station(delta, target_station)
		State.WORKING:
			if target_station == null:
				state = State.IDLE
				return
			target_station.work(delta)

func worker_AI(delta):
	pass

func manager_AI(delta):
	pass

func move_in_zone(delta, target_position):
	var distance = target_position.x - global_position.x
	if abs(distance) < 2:
		velocity.x = 0
		state = State.WORKING
		return
	velocity.x = sign(distance) * working_speed
	velocity.y = 0

func move_to_station(delta, station):
	print("moving")
	if station == null:
		state = State.IDLE
		return
	var distance = station.global_position.x - global_position.x
	# ARRIVED
	if abs(distance) < 5:
		velocity = Vector2.ZERO
		state = State.WORKING
		if not station.is_busy:
			station.is_busy = true
		target_station = station
		move_and_slide()
		return
	# MOVING
	velocity = Vector2(sign(distance) * working_speed, 0)


func handle_drag():
	global_position = get_global_mouse_position() + Vector2(0, 8)

func start_drag():
	if DragManager.dragged_employee != null:
		return 
	DragManager.dragged_employee = self
	state = State.DRAGGING

func stop_drag():

	state = State.IDLE
	
	var zone = get_zone_under_mouse()
	if zone != null:
		apply_zone(zone)
	else:
		position = current_zone.default_position
	if DragManager.dragged_employee == self:
		DragManager.dragged_employee = null

func apply_zone(zone):
	employee_type = zone.tier_type
	current_zone = zone
	position.y = zone.default_position.y

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if DragManager.dragged_employee != null and DragManager.dragged_employee != self:
				return
			if event.pressed:
				start_drag()
			else:
				stop_drag()

func find_station():
	if current_zone == null:
		return
	var closest = null
	var best_dist = INF
	for s in current_zone.get_children():
		if s is WorkStation and !s.is_busy:
			var d = global_position.distance_to(s.global_position)
			if d < best_dist:
				best_dist = d
				closest = s
	target_station = closest

func get_zone_under_mouse() -> Area2D:
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	var results = space_state.intersect_point(query)
	for r in results:
		var obj = r.collider
		if obj is Area2D and obj.is_in_group("employee_zone"):
			return obj
	return null
