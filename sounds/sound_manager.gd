extends Node
const CASH_FAIL = preload("res://sounds/cash_fail.wav")

func action_fail():
	play_sound(CASH_FAIL)

func play_sound(sound : AudioStream):
	var audio_instance = AudioStreamPlayer.new()
	audio_instance.stream = sound
	get_tree().root.add_child(audio_instance)
	audio_instance.play()
	await audio_instance.finished
	audio_instance.queue_free()
	
