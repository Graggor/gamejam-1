extends Node2D

onready var animation_player = $AnimationPlayer
onready var tuuter = $Tuuter
onready var car_sound = $Car
onready var camera = $Camera2D
onready var pause_menu = $Camera2D/PauseMenu
var down = true
var attacking = false
var movement = 34
var crash_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	crash_sound = preload("res://audio/sounds/Car/crash.wav")
	animation_player.play("driving")

func _physics_process(delta):
	if Input.is_action_just_pressed("attack") && attacking == false:
		attacking = true
		animation_player.play("finger")
		yield(animation_player, "animation_finished")
		attacking = false
		animation_player.play("driving")
		
	if Input.is_action_just_pressed("jump"):
		
		tuuter.play()

func _unhandled_input(event):
	if event.is_action_pressed("move_up") && down:
		down = false
		camera.position.y += movement
		position.y -= movement
	elif event.is_action_pressed("move_down") && !down:
		down = true
		camera.position.y -= movement
		position.y += movement
	if event.is_action_pressed("attack") && !attacking:
		attacking = true
		animation_player.play("finger")
		yield(animation_player, "animation_finished")
		animation_player.play("driving")
		attacking = false
	if event.is_action_pressed("ui_cancel"):
		pause_menu.visible = true
		get_tree().paused = true


func _on_Range_body_entered(body):
	body.scare()


func _on_Hitbox_area_entered(area):
	area.take_damage(2000)
	
func take_damage(damage):
	get_tree().paused = true
	animation_player.stop()
	car_sound.stop()
	car_sound.stream = crash_sound
	car_sound.play()
	yield(car_sound, "finished")
	SceneChanger.change_scene("res://Cutscenes/OutroCutscene.tscn")
