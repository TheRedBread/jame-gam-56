extends WorkStation



func get_computer_detection_chance() -> float:
	return reserved_by.working_speed/4.0 # ~1/4

func _ready() -> void:
	pass

func work(delta, employee):
	pass

func detects_theft(employee: Employee) -> bool:
	if reserved_by == null:
		return false
	# Employee is bribed
	if reserved_by.corruption > randf_range(0, 1):
		Global.do_text_popup("employee was bribed", reserved_by.global_position + Vector2(-20, -20), reserved_by, Color.from_rgba8(79, 24, 4))
		return false
	
	# not corrupt employee tries to detect theft
	if get_computer_detection_chance() > randf_range(0, 1):
		return true
	return false
