extends Node2D

onready var animation_player = $AnimationPlayer
onready var tuuter = $Tuuter
onready var camera = $Camera2D
var down = true
var attacking = false
var movement = 34

# Called when the node enters the scene tree for the first time.
func _ready():
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


func _on_Range_body_entered(body):
	body.scare()


func _on_Hitbox_area_entered(area):
	area.take_damage(2000)
	
func take_damage(damage):
	print("dead")
