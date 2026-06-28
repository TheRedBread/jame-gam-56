extends Area2D

@export var station_type: PackedScene
var stations: Array[WorkStation] = []

@export var tier_type : EmployeeTypes.EmployeeType
@export var default_position : Vector2

var boost_scale : float = 1

@export var carrot_spawn_timer_reset_time : float = 100
var carrot_spawn_timer : float = carrot_spawn_timer_reset_time

func spawn_station(pos: Vector2):
	if station_type == null:
		print("No station is set to instantiate")
		return
	
	var s = station_type.instantiate()
	add_child(s)
	s.global_position.x = pos.x
	s.global_position.y = default_position.y
	stations.append(s)

func spawn_carrot():
	spawn_station(Vector2(randf_range(20, 480), default_position.y))

func _ready() -> void:
	if tier_type == EmployeeTypes.EmployeeType.FARMER:
		spawn_carrot()

func _handle_carrot_spawning(delta):
	if $"../../Booster".is_boosted:
		boost_scale = 5
	else:
		boost_scale = 1
	
	carrot_spawn_timer -= Global.carrot_spawn_rate*delta*60*boost_scale
	if carrot_spawn_timer <= 0 and Global.carrots_on_ground < 60:
		spawn_carrot()
		carrot_spawn_timer = carrot_spawn_timer_reset_time

func _physics_process(delta: float) -> void:
	if tier_type == EmployeeTypes.EmployeeType.FARMER:
		_handle_carrot_spawning(delta)
	
