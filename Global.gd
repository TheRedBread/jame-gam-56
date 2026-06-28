extends Node

@export var employee_price : int = 2

var carrots_currency : float = 10
var carrots_in_process : int = 0
var carrots : int = 0
var processed_carrots : int = 0
var processed_carrots_value : float = 2.5
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
