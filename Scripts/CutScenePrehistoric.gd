extends Node2D

onready var animationplayer = $AnimationPlayer
export (String) var scene

func _ready():
	SceneChanger.connect("scene_changed", self, "_on_scene_load")
	animationplayer.play("player_to_cave")

func _on_scene_load():
	animationplayer.play("player_to_cave")
	yield(animationplayer, "animation_finished")
	SceneChanger.change_scene(scene)
