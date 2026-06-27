extends CharacterBody2D

enum State {
	IDLE,
	MOVING,
	WORKING,
	DRAGGING
}
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var wage_expectancy: float
var working_speed: float = 1.0
var walking_speed: float = 25.0
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
	_update_animation()

func _run_ai(delta: float) -> void:
	match employee_type:
		EmployeeTypes.EmployeeType.FARMER:
			_farmer_ai(delta)
		EmployeeTypes.EmployeeType.WORKER:
			_worker_ai(delta)
		EmployeeTypes.EmployeeType.MANAGER:
			_manager_ai(delta)


# -----------------------
# AI
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
			global_position = target_station.global_position
			target_station.work(delta, working_speed)

func _worker_ai(delta : float):
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
			global_position = target_station.global_position
			target_station.work(delta, working_speed)

func _manager_ai(delta: float) -> void:
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
			target_station.work(delta, working_speed)


func _reset_to_idle():
	if target_station and target_station.reserved_by == self:
		target_station.reserved_by = null
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
		if target_station.is_available():
			station.is_busy = true
			target_station = station
		return
	# MOVING
	_move_towards_x(dx)


func _move_towards_x(dx: float) -> void:
	velocity.x = sign(dx) * walking_speed
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
		if child is WorkStation and child.is_available():
			child.reserved_by = self
			var d = global_position.distance_to(child.global_position)
			if d < best_dist:
				best_dist = d
				# release previous best (important cleanup)
				if best and best.reserved_by == self:
					best.reserved_by = null
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
	if target_station and target_station.reserved_by == self:
		target_station.reserved_by = null
		target_station = null


# -----------------------
# ZONE LOGIC
# -----------------------
func _apply_zone(zone: Area2D):
	employee_type = zone.tier_type
	current_zone = zone
	global_position.y = zone.default_position.y
	_play_anim("idle")
	_update_animation()


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

# -----------------------
# Animations/Visuals
# -----------------------

var current_animation := ""

func _update_animation():
	match state:
		State.IDLE:
			_play_anim("idle")
		State.MOVING:
			_play_anim("walk")
		State.WORKING:
			_play_anim("work")

func _play_anim(name: String):
	var employee_type_string := ""
	match employee_type:
		EmployeeTypes.EmployeeType.FARMER:
			employee_type_string = "farm"
		EmployeeTypes.EmployeeType.WORKER:
			employee_type_string = "worker"
		EmployeeTypes.EmployeeType.MANAGER:
			employee_type_string = "manager"
	
	var animation_name = employee_type_string + "_" + name
	
	if current_animation == animation_name:
		return
	
	current_animation = name
	animation_player.play(animation_name)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"farm_work":
			if target_station != null:
				target_station.finish_work()
