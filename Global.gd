extends Node

@export var employee_price : int = 2

var carrots_currency : float = 10
var carrots_in_process : int = 0
var carrots : int = 0
var processed_carrots : int = 0
var processed_carrots_value : float = 2.5
var processed_carrots_value_manager_bonus : float = 0
var carrots_on_ground : int = 0
@export var carrot_spawn_rate : float = 0.2
const BLACK_AND_WHITE = preload("res://UI/black_and_white_theme/black_and_white.tres")
const POPUP_TEXT = preload("res://UI/popup_text.tscn")

@export var farmer_avg_paygrade : float = employee_price*1./10.
@export var worker_avg_paygrade : float = employee_price*2./10.
@export var manager_avg_paygrade : float = employee_price*3./10.

var farmer_paygrade : float = farmer_avg_paygrade
var worker_paygrade : float = worker_avg_paygrade
var manager_paygrade : float = manager_avg_paygrade

func increase_carrot_spawn_rate():
	carrot_spawn_rate += 0.075

func get_processed_carrots_value():
	return processed_carrots_value + processed_carrots_value_manager_bonus

func get_fertilize_price():
	return snappedf( 8 + (carrot_spawn_rate*(carrot_spawn_rate/10) * 300), 0.01)

func do_popup(child_node : Node, pos : Vector2, requester : Variant):
	var popup = POPUP_TEXT.instantiate()
	popup.find_child("AnimationContainer").add_child(child_node)
	requester.add_child(popup)
	popup.global_position = pos

func do_text_popup(text : String, pos : Vector2, requester : Variant, color : Color):
	var label = Label.new()
	label.text = text
	label.theme = BLACK_AND_WHITE
	label.set("theme_override_colors/font_color", color)
	label.horizontal_alignment =HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	do_popup(label, pos, requester)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			DragManager.dragged_employee = null
