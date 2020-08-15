extends Node2D

var wants_to_cancel = false
onready var label = $Label
onready var escape_timer = $EscapeTimer

func _ready():
	label.visible = false
	$AnimationPlayer.play("ok")
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if wants_to_cancel:
			go_to_level()
		else:
			escape_timer.start()
			label.visible = true
			wants_to_cancel = true


func _on_AnimationPlayer_animation_finished(_anim_name):
	go_to_level()

func go_to_level():
	SceneChanger.change_scene("res://Levels/Level1.tscn")


func _on_EscapeTimer_timeout():
	label.visible = false
	wants_to_cancel = false
