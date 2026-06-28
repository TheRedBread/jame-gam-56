extends Node2D
class_name WorkStation

var reserved_by: Employee = null
var has_work_to_do : bool = true

func is_available() -> bool:
	return reserved_by == null

func try_reserve(employee: CharacterBody2D) -> bool:
	if reserved_by != null:
		return false
	reserved_by = employee
	return true

func release(employee: CharacterBody2D) -> void:
	if reserved_by == employee:
		reserved_by = null

func work(delta: float, employee : Employee):
	pass

func finish_work():
	pass
