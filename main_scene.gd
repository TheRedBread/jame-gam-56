extends Node2D

const employee := preload("res://Employee/employee.tscn")
const CASH = preload("res://sounds/cash.wav")
@onready var employee_inspector_menu: Control = %EmployeeInspectorMenu
const POPUP_TEXT = preload("res://UI/popup_text.tscn")
const BLACK_AND_WHITE = preload("res://UI/black_and_white_theme/black_and_white.tres")
@onready var camera_2d: Camera2D = $Camera2D
@onready var camera_start_position := camera_2d.position
const CAMERA_SCROLL_MARGIN := 20 
const CAMERA_SCROLL_SPEED := 400.0
var employee_list : Array

func get_current_pyramid():
	return find_child("Pyramid")

func spawn_new_employee() -> void:
	var new_employee = employee.instantiate()
	new_employee.setup(get_current_pyramid().find_child("FarmZone"), self)
	add_child(new_employee)


func _ready() -> void:
	spawn_new_employee()

func _on_button_pressed() -> void:
	if Global.carrots_currency >= Global.employee_price:
		SoundManager.play_sound(CASH)
		Global.carrots_currency -= Global.employee_price
		spawn_new_employee()
	else:
		SoundManager.action_fail()

func _process(delta: float) -> void:
	%CarrotCounter.text = "CarrotCoins (cc): " + str(Global.carrots_currency) 
	$NewEmployeeButton.text = "Hire " + str(Global.employee_price) + "cc"
	
	handle_camera(delta)

func get_employees() -> Array:
	return get_tree().get_nodes_in_group("employee")

func get_employees_with_tier_type(type : EmployeeTypes.EmployeeType) -> Array:
	var employee_array : Array
	for employee : Employee in get_employees():
		if employee.employee_type == type:
			employee_array.append(employee)
	return employee_array

func _pay(amount : float) -> bool:
	if amount > Global.carrots_currency:
		return false
	Global.carrots_currency -= amount
	return true
	

func _pay_employees():
	var farmers_count = get_employees_with_tier_type(EmployeeTypes.EmployeeType.FARMER).size()
	var workers_count = get_employees_with_tier_type(EmployeeTypes.EmployeeType.WORKER).size()
	var managers_count = get_employees_with_tier_type(EmployeeTypes.EmployeeType.MANAGER).size()
	var payment = farmers_count*Global.farmer_paygrade + workers_count*Global.worker_paygrade + managers_count*Global.manager_paygrade
	
	if (!_pay(payment)):
		Global.farmer_paygrade = 0
		Global.worker_paygrade = 0
		Global.manager_paygrade = 0
		$ManagementZonePaymentControl.display_text()
		$WorkerZonePaymentControl.display_text()
		$FarmerZonePaymentControl.display_text()
		Global.do_text_popup("You didn't pay employees", Vector2(115, 15), self, Color.from_rgba8(241, 167, 122))
	Global.do_text_popup("Payed Employees: " + str(payment), Vector2(115, 15), self, Color.from_rgba8(241, 167, 122))
	

func _on_pay_timer_timeout() -> void:
	_pay_employees()

func handle_camera(delta):
	if %MillTimer.time_left > 0:
		return
	
	var target_y : float = camera_2d.position.y
	if DragManager.dragged_employee != null:
		var screen_pos = get_global_mouse_position()
		if screen_pos.y > get_viewport_rect().size.y - CAMERA_SCROLL_MARGIN:
			target_y = 50.0
		else:
			target_y = camera_start_position.y
	else:
		target_y = camera_start_position.y
	camera_2d.position.y = lerp(camera_2d.position.y, target_y, 0.15)

func _on_human_saw_milled() -> void:
	%MillTimer.start()
	for employee in get_employees():
		employee.satisfaction -= 0.1
