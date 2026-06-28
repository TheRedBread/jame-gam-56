extends Node2D

func spawn_computer(pos : Vector2):
	$ManagementZone.spawn_station(pos)

func spawn_fabricator(pos : Vector2):
	$FactoryZone.spawn_station(pos)
