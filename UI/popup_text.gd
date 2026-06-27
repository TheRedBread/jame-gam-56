extends Node2D

@onready var animation_container: Node2D = $AnimationContainer

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
