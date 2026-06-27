extends Area2D

signal milled
const BLENDER = preload("res://sounds/blender.wav")

func mill():
	milled.emit()
	$MillAnimationPlayer.play("mill")
	SoundManager.play_sound(BLENDER)
