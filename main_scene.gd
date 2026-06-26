extends Node2D

const employee := preload("res://Employee/employee.tscn")

var employee_list : Array

func get_current_pyramid():
	return find_child("Pyramid")

func _on_button_pressed() -> void:
	var new_employee = employee.instantiate()
	new_employee.setup(get_current_pyramid().find_child("FarmZone"))
	add_child(new_employee)
