extends WorkStation

@export var carrot_timer : float
@onready var fabricator_animation_player: AnimationPlayer = $FabricatorAnimationPlayer
@onready var button_animation_player: AnimationPlayer = $ButtonAnimationPlayer

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
		$ProgressBar.show()
	else:
		has_work_to_do = false
		$ProgressBar.hide()

func handle_animation():
	if !fabricator_animation_player.is_playing():
		$FabricatorAnimationPlayer.play("process_carrots")
	if !button_animation_player.is_playing():
		$ButtonAnimationPlayer.play("press_button")

func work(delta, employee):
	progress -= ((employee.working_speed)*delta*60)/4
	$ProgressBar.value = init_progress - progress
	if (progress <= 0):
		finish_work()
	handle_animation()

func finish_work():
	Global.processed_carrots += 1
	progress = init_progress
	carrot_inside = false
