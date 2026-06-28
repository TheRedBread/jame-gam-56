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
	progress -= ((employee.working_speed)*delta*60)/3
	$ProgressBar.value = init_progress - progress
	if (progress <= 0):
		finish_work()
	handle_animation()

func finish_work():
	if reserved_by.corruption > randf_range(0, 1):
		# worker tries theft
		var caught := false
		for computer in get_tree().get_nodes_in_group("computers"):
			if computer.detects_theft(reserved_by):
				caught = true
				break
		
		if caught:
			reserved_by.corruption = clampf(reserved_by.corruption - 0.1, 0, 1)
			Global.processed_carrots += 1
			Global.do_text_popup("theft detected", reserved_by.global_position + Vector2(-20, -20), reserved_by, Color.from_rgba8(81, 169, 79))
		else:
			reserved_by.do_corruption_act()
	else:
		# worker doesn't steal
		Global.processed_carrots += 1
	progress = init_progress
	carrot_inside = false
