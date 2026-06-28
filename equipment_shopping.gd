extends Area2D

const RABBIT_PICKUP = preload("res://sounds/rabbit_pickup.wav")
const RABBIT_DROP = preload("res://sounds/rabbit_drop.wav")
@onready var sprite_2d: Sprite2D = $Sprite2D
const MANAGERS_COMPUTER = preload("res://workstations/managers_computer.png")
const MASZYNKA_MARCHEWEK_SINGLE = preload("res://workstations/maszynka-marchewek-single.png")

var is_dragged : bool = false

signal buy_equipment(type, place)

@export var tier : EmployeeTypes.EmployeeType
@export var price : float = 0

@export var default_pos : Vector2

func _physics_process(delta: float) -> void:
	_handle_drag()

func _ready() -> void:
	default_pos = global_position
	if tier == EmployeeTypes.EmployeeType.WORKER:
		sprite_2d.texture = MASZYNKA_MARCHEWEK_SINGLE
	if tier == EmployeeTypes.EmployeeType.MANAGER:
		sprite_2d.texture = MANAGERS_COMPUTER

func start_drag():
	is_dragged = true
	SoundManager.play_sound(RABBIT_PICKUP)

func stop_drag():
	is_dragged = false
	SoundManager.play_sound(RABBIT_DROP)
	var zone = _get_zone_under_mouse()
	if zone != null and zone.has_method("spawn_station") and zone.tier_type == tier:
		buy_equipment.emit(tier, global_position)
	global_position = default_pos


func _handle_drag():
	if is_dragged:
		global_position = get_global_mouse_position() + Vector2(0, 8)

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


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()
			else:
				stop_drag()
