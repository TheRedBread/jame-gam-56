extends WorkStation

func _ready() -> void:
	pass

func work(delta, working_speed):
	pass

func finish_work():
	print("carrot fin")
	Global.carrots += 1
	queue_free()
