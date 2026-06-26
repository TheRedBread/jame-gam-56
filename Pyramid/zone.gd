extends Area2D

@export var station_type: PackedScene
var stations: Array[WorkStation] = []

@export var tier_type : EmployeeTypes.EmployeeType
@export var default_position : Vector2

func spawn_station(pos: Vector2):
	if station_type == null:
		print("No station is set to instantiate")
		return
	
	var s = station_type.instantiate()
	add_child(s)
	s.global_position = pos
	stations.append(s)


func _ready() -> void:
	spawn_station(default_position)
