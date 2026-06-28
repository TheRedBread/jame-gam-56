extends Control


@export var tier : EmployeeTypes.EmployeeType
const BUTTON_PRESS = preload("res://sounds/button_press.wav")

func _ready() -> void:
	display_text()

func change_pay(amount : float) -> void:
	match tier:
		EmployeeTypes.EmployeeType.FARMER:
			Global.farmer_paygrade = clampf(Global.farmer_paygrade + amount, 0, 100)
		EmployeeTypes.EmployeeType.WORKER:
			Global.worker_paygrade = clampf(Global.worker_paygrade + amount, 0, 100)
		EmployeeTypes.EmployeeType.MANAGER:
			Global.manager_paygrade = clampf(Global.manager_paygrade + amount, 0, 100)
	display_text()

func get_tier_pay():
	match tier:
		EmployeeTypes.EmployeeType.FARMER:
			return Global.farmer_paygrade
		EmployeeTypes.EmployeeType.WORKER:
			return Global.worker_paygrade
		EmployeeTypes.EmployeeType.MANAGER:
			return Global.manager_paygrade


func _on_button_up_pressed() -> void:
	SoundManager.play_sound(BUTTON_PRESS)
	change_pay(0.05)


func _on_button_down_pressed() -> void:
	change_pay(-0.05)

func display_text():
	var text = " pay: " + str(snappedf(get_tier_pay(), 0.05))
	%MainLabel.text = text
