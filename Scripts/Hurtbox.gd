extends Area2D

onready var parent = get_parent()

func take_damage(damage):
	parent.take_damage(damage)
