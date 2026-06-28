extends WorkStation

const CARROT_PICKUP = preload("res://sounds/carrot_pickup.wav")

func _ready() -> void:
	pass

func work(delta, employee):
	pass


func finish_work():
	SoundManager.play_sound(CARROT_PICKUP)
	if reserved_by == null:
		return
	
	if reserved_by.corruption > randf_range(0, 1):
		# Farmer tries theft
		var caught := false
		for computer in get_tree().get_nodes_in_group("computers"):
			if computer.detects_theft(reserved_by):
				caught = true
				break
		if caught:
			reserved_by.corruption = clampf(reserved_by.corruption - 0.5, 0, 1)
			Global.carrots += 1
			Global.do_text_popup("theft detected", reserved_by.global_position + Vector2(-20, -20), reserved_by, Color.from_rgba8(81, 169, 79))
		else:
			reserved_by.do_corruption_act()
	else:
		# Farmer doesn't steal
		Global.carrots += 1
	queue_free()
