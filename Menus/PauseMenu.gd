extends Control

onready var blip = $BlipSound
onready var selected = $SelectedSound
var is_visible = false
var can_close = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#get_node("Buttons/ContinueButton").grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(visible && !is_visible):
		is_visible = true
		yield(get_tree().create_timer(0.1), "timeout")
		can_close = true
		get_node("Buttons/ContinueButton").grab_focus()

func close_self():
	self.visible = false
	is_visible = false
	yield(get_tree().create_timer(.1), "timeout")
	get_tree().paused = false

func _on_ContinueButton_pressed():
	close_self()

func _on_Button_focus_entered():
	blip.play()


func _on_RestartButton_pressed():
	get_tree().paused = false
	selected.play()
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	selected.play()
	SceneChanger.change_scene("res://Menus/MainMenu.tscn")


func _on_Player_pause():
	get_node("Buttons/ContinueButton").grab_focus()
