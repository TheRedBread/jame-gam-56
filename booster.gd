extends Node2D

var is_boosted : bool = false

func _physics_process(delta: float) -> void:
	if !is_boosted:
		hide()
		return
	$ProgressBar.value = $Timer.time_left/$Timer.wait_time 
	show()

func _on_human_saw_milled() -> void:
	$Timer.start()
	is_boosted = true

func _on_timer_timeout() -> void:
	is_boosted = false
