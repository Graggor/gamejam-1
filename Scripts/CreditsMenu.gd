extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if (event is InputEventKey || event is InputEventJoypadButton) and event.pressed:
		SceneChanger.change_scene("res://Menus/MainMenu.tscn")
