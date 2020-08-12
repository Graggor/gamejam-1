extends KinematicBody2D

const SLOPE_STOP = 64

var health = 100
var move_speed = 5 * Globals.UNIT_SIZE
var max_jump_velocity
var min_jump_velocity
var max_jump_height = 2.2 * Globals.UNIT_SIZE
var min_jump_height = 0.8 * Globals.UNIT_SIZE
var jump_duration = 0.5
var gravity
var is_grounded
var jumping = false
var snap
var attacking = false
var damage = 10
var weapon = "punch"
var walk_pitch = 1.0
var jump_sound

var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var sound = $Sound
onready var code_sound = $CodeSound

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	print(gravity)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
	jump_sound = preload("res://audio/sounds/Player/player_jump3.wav")
	
	$Camera2D/HUD/HealthBar._on_health_updated(health)
	$Camera2D/HUD/HealthBar._on_max_health_updated(health)

func _physics_process(delta):
	if (health <= 0):
		die()
	else:
		_get_input()
		
		if jumping:
			snap = Vector2()
		else:
			snap = Vector2(0,4)
		
		velocity.y += gravity * delta
		is_grounded = is_on_floor()
		velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
		_assign_anim()

func _input(event):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			code_sound.pitch_scale = 1.2
			code_sound.stream = jump_sound
			code_sound.play()
			jumping = true
			velocity.y = max_jump_velocity
			
	if event.is_action_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	if Input.is_action_just_pressed("attack") && attacking == false:
		attacking = true

func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.4)
	
	if move_direction != 0:
		$Body.scale.x = move_direction

func _assign_anim():
	var anim = "idle"
	sound.pitch_scale = 1.0
	
	if attacking:
		anim = weapon
	elif !is_grounded:
		anim = "jump"
	elif !(velocity.x < 0.4 && velocity.x > -0.4):
		anim = "walk"
		sound.pitch_scale = walk_pitch
	
	animation_player.play(anim)


func _on_Hitbox_area_entered(area):
	area.take_damage(damage)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == weapon):
		attacking = false

func change_weapon(new_weapon, new_damage):
	weapon = new_weapon
	damage = new_damage

func take_damage(damage_taken):
	health -= damage_taken
	print(health)
	$Camera2D/HUD/HealthBar._on_health_updated(health)

func die():
	get_tree().reload_current_scene()

func randomize_pitch():
	randomize()
	walk_pitch = rand_range(2, 1)


func _on_PitchTimer_timeout():
	randomize_pitch()
