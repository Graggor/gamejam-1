extends Node2D

onready var animationplayer = $AnimationPlayer
export (String) var scene
export (String) var animation

func _ready():
	SceneChanger.connect("scene_changed", self, "_on_scene_load")
	animationplayer.play(animation)

func _on_scene_load():
	animationplayer.play(animation)
	yield(animationplayer, "animation_finished")
	SceneChanger.change_scene(scene)
