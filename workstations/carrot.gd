extends WorkStation

const CARROT_PICKUP = preload("res://sounds/carrot_pickup.wav")

func _ready() -> void:
	pass

func work(delta, employee):
	pass

func finish_work():
	SoundManager.play_sound(CARROT_PICKUP)
	Global.carrots += 1
	queue_free()
