extends Node2D

@onready var pyramid: Node2D = $"../Pyramid"
var is_hidden : bool = true

func _ready() -> void:
	%ShopPanel.hide()

func _on_equipment_shopping_manager_buy_equipment(type: Variant, place: Variant) -> void:
	if Global.carrots_currency >= 20:
		Global.carrots_currency -= 20
		pyramid.spawn_computer(place)
	else:
		Global.do_text_popup("Not enough cc", place, self, Color.from_rgba8(79, 24, 4))


func _on_equipment_shopping_worker_buy_equipment(type: Variant, place: Variant) -> void:
	if Global.carrots_currency >= 10:
		Global.carrots_currency -= 10
		pyramid.spawn_fabricator(place)
	else:
		Global.do_text_popup("Not enough cc", place, self, Color.from_rgba8(79, 24, 4))


func _on_show_button_pressed() -> void:
	if is_hidden:
		is_hidden = false
		%ShopPanel.show()
	else:
		is_hidden = true
		%ShopPanel.hide()
		
