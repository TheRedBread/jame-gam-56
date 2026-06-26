extends Node2D
class_name WorkStation

var reserved_by: CharacterBody2D = null

func is_available():
	return reserved_by == null

func work(delta):
	pass
