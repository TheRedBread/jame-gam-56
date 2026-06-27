extends Node2D

const employee := preload("res://Employee/employee.tscn")

var employee_list : Array

func get_current_pyramid():
	return find_child("Pyramid")

func spawn_new_employee() -> void:
	var new_employee = employee.instantiate()
	new_employee.setup(get_current_pyramid().find_child("FarmZone"))
	add_child(new_employee)

func _ready() -> void:
	spawn_new_employee()

func _on_button_pressed() -> void:
	if Global.carrots_currency >= Global.employee_price:
		Global.carrots_currency -= 1
		spawn_new_employee()

func _process(delta: float) -> void:
	$CarrotCounter.text = "CarrotCoins (cc): " + str(Global.carrots_currency) 
	$Button.text = "Hire " + str(Global.employee_price) + "cc"
