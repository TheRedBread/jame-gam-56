extends WorkStation

@export var carrot_timer : float

@export var init_progress : float = 100
var progress : float = init_progress

var carrot_inside := false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not carrot_inside and Global.carrots_in_process >= 1:
		Global.carrots_in_process -= 1
		carrot_inside = true
	
	if carrot_inside:
		has_work_to_do = true
	else:
		has_work_to_do = false


func work(delta, employee):
	progress -= (employee.working_speed)*delta*60
	if (progress <= 0):
		finish_work()

func finish_work():
	Global.processed_carrots += 1
	progress = init_progress
	carrot_inside = false
