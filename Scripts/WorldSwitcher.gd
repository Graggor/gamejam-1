extends Node2D

export (String) var next_level

func switch_level():
	SceneChanger.change_scene(next_level)

func _on_Mammoth_mammoth_died():
	switch_level()
