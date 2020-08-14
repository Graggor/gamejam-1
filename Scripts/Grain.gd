extends Node2D

var bread = preload("res://Levels/Pickups/Bread.tscn")

onready var animationplayer = $AnimationPlayer

func _ready():
	animationplayer.play("idle")

func take_damage(_damage):
	var drop = bread.instance()
	drop.position = position
	get_parent().add_child(drop)
	queue_free()	
