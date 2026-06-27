extends Node2D
class_name WorkStation

var reserved_by: CharacterBody2D = null

func is_available():
	return reserved_by == null

func work(delta, working_speed):
	pass

func finish_work():
	pass
