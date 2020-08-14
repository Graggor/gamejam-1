extends Node2D

onready var animationplayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationplayer.play("idle")

func _on_Hitbox_area_entered(area):
	area.take_damage(1000)
