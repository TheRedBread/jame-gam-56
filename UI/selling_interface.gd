extends Control

@onready var selling_container: PanelContainer = $SellingContainer
const BUTTON_PRESS = preload("res://sounds/button_press.wav")
const CASH = preload("uid://dvl6r88b61egp")

var is_hidden : bool = true

func _ready() -> void:
	selling_container.hide()
	update_shop_items()

func update_shop_item(item : HBoxContainer, amount : int, value : float, item_name : String):
	find_child_of_type_and_substr(item, Button, "Sell").text = "Sell " + str(snappedf(amount * value, 0.5))
	find_child_of_type_and_substr(item, Label, "Label").text = str(amount) + " " + item_name

func _process(delta: float) -> void:
	update_shop_items()

func update_shop_items():
	update_shop_item(%CarrotsSell, Global.carrots, 1, "Carrots")
	update_shop_item(%ProcessedCarrotsSell, Global.processed_carrots, Global.processed_carrots_value, "Processed Carrots")

func find_child_of_type_and_substr(parent, type, substr):
	for child in parent.get_children():
		if is_instance_of(child, type) and substr in child.name:
			return child
		var grandchild = find_child_of_type_and_substr(child, type, substr)
		if grandchild != null:
			return grandchild
	return null

func _on_caroot_sell_button_pressed() -> void:
	if Global.carrots <=0:
		SoundManager.action_fail()
		return
	SoundManager.play_sound(CASH)
	Global.carrots_currency += Global.carrots
	Global.carrots = 0
	update_shop_items()
	


func _on_show_sell_button_pressed() -> void:
	SoundManager.play_sound(BUTTON_PRESS)
	if is_hidden == true:
		selling_container.show()
		is_hidden = false
	else:
		selling_container.hide()
		is_hidden = true
	update_shop_items()


func _on_carrot_send_to_process_button_pressed() -> void:
	if Global.carrots <=0:
		SoundManager.action_fail()
		return
	SoundManager.play_sound(BUTTON_PRESS)
	Global.carrots_in_process += Global.carrots
	Global.carrots = 0
	update_shop_items()


func _on_processed_carrot_sell_button_pressed() -> void:
	if Global.processed_carrots <=0:
		SoundManager.action_fail()
		return
	SoundManager.play_sound(CASH)
	Global.carrots_currency += Global.processed_carrots * Global.processed_carrots_value
	Global.processed_carrots = 0
	update_shop_items()
