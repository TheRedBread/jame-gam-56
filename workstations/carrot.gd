extends WorkStation

func _ready() -> void:
	pass

func work(delta, employee):
	pass

func finish_work():
	Global.carrots += 1
	queue_free()
