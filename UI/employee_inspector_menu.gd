extends Control

@onready var properties_text: RichTextLabel = %PropertiesText
var is_visible : bool = false

func _ready() -> void:
	hide()

func compile_property_string(property_name, property_value):
	return "[p]" + property_name+": " + str(property_value) + "[/p]"

func to_procent(value : float):
	return str(int(value * 100)) + "%" 

func show_properties(employee : Employee):
	show()
	var inspector_text_string : String = ""
	inspector_text_string += compile_property_string("Satisfaction", to_procent(employee.satisfaction))
	inspector_text_string += compile_property_string("Corruption tendencies", to_procent(employee.corruption))
	inspector_text_string += compile_property_string("Wage expectancy", employee.wage_expectancy)
	inspector_text_string += compile_property_string("Working speed", to_procent(employee.working_speed))
	inspector_text_string += compile_property_string("Walking speed", employee.walking_speed)
	properties_text.text = inspector_text_string


func _on_close_button_pressed() -> void:
	hide()
