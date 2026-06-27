extends Control

func _process(delta: float) -> void:
	find_child_of_type(%CarrotsSell, Button).text = "Sell " + str(Global.carrots) + "cc"
	find_child_of_type(%CarrotsSell, Label).text = str(Global.carrots) + " Carrots"

func find_child_of_type(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		var grandchild = find_child_of_type(child, type)
		if grandchild != null:
			return grandchild
	return null

func _on_caroot_sell_button_pressed() -> void:
	Global.carrots_currency += Global.carrots
	Global.carrots = 0
