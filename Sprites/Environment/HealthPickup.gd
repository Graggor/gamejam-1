extends Node2D

export (String) var food
onready var animationplayer = $AnimationPlayer

func _ready():
	animationplayer.play("drop")
	yield(animationplayer, "animation_finished")
	animationplayer.play("idle")


func _on_Area2D_body_entered(body):
	$Area2D/CollisionShape2D.disabled = true
	body.feed(food)
	queue_free()
