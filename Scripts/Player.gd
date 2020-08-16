extends KinematicBody2D

const SLOPE_STOP = 64

var health = 100.0
var hunger = 100.0
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
var damage = 1.9
var weapon = "punch"
var walk_pitch = 1.0
var jump_sound
var heart_time = 0
var heart_step = 1
var max_heart_time = 60
var heart_start
var heart_damage
var heals_left
var max_heals = 5
var bread_sound
var meat_sound
var get_hit_sound
var die_sound
var pre
export (bool) var is_medieval

var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var sound = $Sound
onready var code_sound = $CodeSound
onready var code_sound2 = $CodeSound2
onready var heart_music = $HeartMusic
onready var hungertimer = $HungerTimer
onready var healtimer = $HealTimer
onready var hungerdamagetimer = $HungerDamageTimer
onready var coyotetimer = $CoyoteTimer
onready var damageplayer = $DamagePlayer
onready var pause_menu = $Camera2D/PauseMenu

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	print(gravity)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
		
	if is_medieval:
		pre = "medieval_"
		damage = 4
		weapon = "stick"
	else:
		pre = ""
	
	heals_left = max_heals
	
	jump_sound = preload("res://audio/sounds/Player/player_jump3.wav")
	bread_sound = preload("res://audio/sounds/Player/eat_bread.wav")
	meat_sound = preload("res://audio/sounds/Player/eat_meat.wav")
	get_hit_sound = preload("res://audio/sounds/Player/player_hurt1.wav")
	die_sound = preload("res://audio/sounds/Player/death.wav")
	
	heart_start = (hunger / max_heart_time) * 24
	heart_damage = hunger / max_heart_time
	
	$Camera2D/HUD/HealthBar._on_health_updated(health)
	$Camera2D/HUD/HealthBar._on_max_health_updated(health)
	$Camera2D/HUD/HungerBar._on_hunger_updated(hunger)
	$Camera2D/HUD/HungerBar._on_max_hunger_updated(hunger)

func _physics_process(delta):
	if (health <= 0):
		die()
	else:
		_get_input()
		
		heart_time += delta
		if heart_time >= heart_step && hungertimer.is_stopped() && hunger > 0:
			take_hunger(heart_damage)
			heart_time = 0
		
		if hunger <= 0 && hungerdamagetimer.is_stopped():
			hungerdamagetimer.start()
		
		if hunger < heart_start && !heart_music.is_playing():
			heart_music.play()
		if hunger > heart_start:
			heart_music.stop()
			
		if jumping:
			snap = Vector2()
		else:
			snap = Vector2(0,4)
		
		velocity.y += gravity * delta
		
		if jumping && velocity.y >= 0:
			jumping = false
		
		var was_on_floor = is_on_floor()
		
		velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
		
		if !is_on_floor() && was_on_floor && !jumping:
			coyotetimer.start()
		
		is_grounded = is_on_floor()
		_assign_anim()

func _input(event):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || !coyotetimer.is_stopped():
			coyotetimer.stop()
			code_sound.pitch_scale = 1.2
			code_sound.stream = jump_sound
			code_sound.play()
			jumping = true
			velocity.y = max_jump_velocity
			
	if event.is_action_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	if Input.is_action_just_pressed("attack") && attacking == false:
		attacking = true
	
	if event.is_action_pressed("ui_cancel"):
		pause_menu.visible = true
		get_tree().paused = true

func _get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.4)
	
	if move_direction != 0:
		$Body.scale.x = move_direction

func _assign_anim():
	
	var anim = "%sidle" % [pre]
	sound.pitch_scale = 1.0
	
	if attacking:
		anim = pre + weapon
	elif !is_grounded:
		anim = "%sjump" % [pre]
	elif !(velocity.x < 0.4 && velocity.x > -0.4):
		anim = "%swalk" % [pre]
		sound.pitch_scale = walk_pitch
	
	animation_player.play(anim)


func _on_Hitbox_area_entered(area):
	area.take_damage(damage)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == pre + weapon):
		attacking = false

func change_weapon(new_weapon, new_damage):
	weapon = new_weapon
	damage = new_damage

func take_damage(damage_taken):
	damageplayer.play("damage")
	health -= damage_taken
	$Camera2D/HUD/HealthBar._on_health_updated(health)
	code_sound2.stop()
	code_sound2.stream = get_hit_sound
	code_sound2.play()

func take_hunger(hunger_taken):
	hunger -= hunger_taken
	$Camera2D/HUD/HungerBar._on_hunger_updated(hunger)

func die():
	get_tree().paused = true
	animation_player.play(pre + "die")
	yield(animation_player, "animation_finished")
	get_tree().paused = false
	get_tree().reload_current_scene()

func randomize_pitch():
	randomize()
	walk_pitch = rand_range(2, 1)

func heal():
	health += 10
	$Camera2D/HUD/HealthBar._on_health_updated(health)

func feed(food):
	hunger = 100.0
	hungerdamagetimer.stop()
	hungertimer.stop()
	if health < 100:
		healtimer.start()
	hungertimer.start()
	$Camera2D/HUD/HungerBar._on_hunger_updated(hunger)
	if food == "meat":
		code_sound2.stream = meat_sound
	elif food == "bread":
		code_sound2.stream = bread_sound
	
	code_sound2.pitch_scale = 1
	code_sound2.play()
	
func talk(words):
	$Label.text = words
	yield(get_tree().create_timer(1.5), "timeout")
	$Label.text = ""
	

func _on_PitchTimer_timeout():
	randomize_pitch()


func _on_HealTimer_timeout():
	heals_left -= 1
	if heals_left <= 0:
		healtimer.stop()
		heals_left = max_heals
	elif health < 100:
		heal()


func _on_HungerDamageTimer_timeout():
	take_damage(10)
