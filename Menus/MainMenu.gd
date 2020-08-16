extends Control

onready var blip = $BlipSound
onready var selected = $SelectedSound


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Buttons/StartButton").grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	selected.play()
	SceneChanger.change_scene("res://Cutscenes/IntroCutscene.tscn")


func _on_Button_focus_entered():
	print("focus grabbed")
	blip.play()


func _on_ExitButton_pressed():
	selected.play()
	SceneChanger.quit_game()


func _on_SettingsButton_pressed():
	selected.play()
	SceneChanger.change_scene("res://Menus/SettingsMenu.tscn")


func _on_CreditButton_pressed():
	selected.play()
	SceneChanger.change_scene("res://Menus/CreditsMenu.tscn")
