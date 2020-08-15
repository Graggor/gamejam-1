extends Control

onready var overall_slider = $Buttons/Overall/Overall
onready var music_slider = $Buttons/Music/Music
onready var audio_slider = $Buttons/Audio/Audio
onready var blip = $BlipSound
onready var selected = $SelectedSound

# Called when the node enters the scene tree for the first time.
func _ready():
	overall_slider.grab_focus()
	overall_slider.min_value = 0.001
	overall_slider.step = 0.01
	music_slider.min_value = 0.001
	music_slider.step = 0.01
	audio_slider.min_value = 0.001
	audio_slider.step = 0.01
	
	print(db2linear(AudioServer.get_bus_volume_db(0)))
	print(db2linear(AudioServer.get_bus_volume_db(1)))
	print(db2linear(AudioServer.get_bus_volume_db(2)))
	
	print(AudioServer.get_bus_volume_db(1))
	print(AudioServer.get_bus_volume_db(2))
	
	overall_slider.value = db2linear(AudioServer.get_bus_volume_db(0))
	music_slider.value = db2linear(AudioServer.get_bus_volume_db(1))
	audio_slider.value = db2linear(AudioServer.get_bus_volume_db(2))
	
	overall_slider.connect("value_changed", self, "_on_Overall_value_changed")
	music_slider.connect("value_changed", self, "_on_Music_value_changed")
	audio_slider.connect("value_changed", self, "_on_Audio_value_changed")

func _on_Overall_value_changed(value):
	blip.play()
	AudioServer.set_bus_volume_db(0, linear2db(value))

func _on_Music_value_changed(value):
	blip.play()
	AudioServer.set_bus_volume_db(1, linear2db(value))

func _on_Audio_value_changed(value):
	blip.play()
	AudioServer.set_bus_volume_db(2, linear2db(value))

func _on_BackButton_pressed():
	selected.play()
	SceneChanger.change_scene("res://Menus/MainMenu.tscn", 0)

func _on_Button_focus_entered():
	print("focus grabbed")
	blip.play()
