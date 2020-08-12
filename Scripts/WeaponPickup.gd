extends Area2D

export (String) var weapon
export (int) var damage
onready var audioplayer = $AudioPlayer
onready var animationplayer = $AnimationPlayer
onready var collision = $CollisionShape2D
onready var sprite = $Sprite

func _ready():
	animationplayer.play("idle")

func _on_Weapon_body_entered(body):
	collision.disabled = true
	audioplayer.play()
	sprite.visible = false
	body.change_weapon(weapon, damage)


func _on_AudioPlayer_finished():
	queue_free()
