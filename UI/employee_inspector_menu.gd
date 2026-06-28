extends Control

@onready var properties_text: RichTextLabel = %PropertiesText
var is_visible : bool = false
var current_target : Employee
func _ready() -> void:
	hide()



func compile_property_string(property_name, property_value, after_text = null):
	var text = ""
	text += "[p]" + property_name+": " + str(property_value) 
	if after_text != null:
		text += " " + after_text
	text += "[/p]"
	return text

func to_procent(value : float):
	return str(int(value * 100)) + "%" 

func show_properties(employee : Employee):
	current_target = employee
	show()
	is_visible = true
	var inspector_text_string : String = ""
	inspector_text_string += compile_property_string("Satisfaction", to_procent(employee.satisfaction))
	inspector_text_string += compile_property_string("Corruption predisposition", to_procent(employee.corruption_predisposition))
	inspector_text_string += compile_property_string("Corruption", to_procent(employee.corruption))
	inspector_text_string += compile_property_string("Wage expectancy",  snappedf(employee.wage_expectancy * employee.get_average_payment_of_type(), 0.01), "[img]res://workstations/moneta.png[/img]")
	inspector_text_string += compile_property_string("Working speed", to_procent(employee.working_speed))
	inspector_text_string += compile_property_string("Walking speed", snappedf(employee.walking_speed, 0.01))
	properties_text.text = inspector_text_string
	%UpdateEmployeeTimer.start()


func _on_close_button_pressed() -> void:
	hide()
	is_visible = false


func _on_update_employee_timer_timeout() -> void:
	if current_target != null and is_visible:
		show_properties(current_target)
