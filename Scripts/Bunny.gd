extends KinematicBody2D

var health = 30
var walk_speed = 1 * Globals.UNIT_SIZE
var run_speed = 6 * Globals.UNIT_SIZE
var gravity = 563.2
var state = "walking"
var direction = 1
var velocity = Vector2()
var speed
var run_range
var jump_height = 1.1 * Globals.UNIT_SIZE
var jump_velocity
var running = false
var hit_sounds = []
var playing_sound = false
var meat = preload("res://Levels/Pickups/Meat.tscn")

onready var turnrays = $TurnRays
onready var runtimer = $RunTimer
onready var animationplayer = $AnimationPlayer
onready var jumpray = $JumpRay
onready var sound = $Sound

func _ready():
	jump_velocity = -sqrt(2 * gravity * jump_height)
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit.wav"))
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit02.wav"))
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit03.wav"))	

func take_damage(damage):
	health -= damage
	play_sound(hit_sounds)
	turn_from_player()
	state = "running"
	print(health)

func _physics_process(delta):
	if (health <= 0 && state != "dead"):
		state = "dead"
		die()
		
	velocity.y += gravity * delta
	
	match state:
		"walking":
			assign_anim("walking")
			speed = walk_speed
			if(check_turn(true)):
				turn_around()
		"running":
			assign_anim("running")
			speed = run_speed
			if runtimer.is_stopped() && !running:
				running = true
				runtimer.start()
			if jumpray.is_colliding() && is_on_floor():
				jump()
		"dead":
			pass
		
	velocity.x = lerp(velocity.x, speed * direction, 0.4)
	velocity = move_and_slide(velocity, Vector2.UP)

func turn_from_player():
	var player = get_owner().get_node("Player")
	var turndirection = position.direction_to(player.position)
	if turndirection.x > 0:
		if direction != -1:
			turn_around()
	else:
		if direction != 1:
			turn_around()

func play_sound(sounds):
	randomize()
	sounds.shuffle()
	sound.stream = sounds.front()
	sound.play()
	

func jump():
	if is_on_floor():
		velocity.y = jump_velocity

func close_to_player():
	var player = get_owner().get_node("Player")
	var to_player = player.global_position.x - global_position.x
	var distance = max(to_player, -to_player)
	if (distance <= run_range):
		return true
	return false

func check_turn(check_floor):
	if $TurnRays/Wall.is_colliding():
		return true
	if !$TurnRays/Floor.is_colliding() && check_floor:
		return true
	return false

func turn_around():
	scale.x = -scale.x
	direction = -direction

func assign_anim(anim):
	if animationplayer.assigned_animation != anim:
		animationplayer.play(anim)

func die():
	var drop = meat.instance()
	drop.position = position
	get_parent().add_child(drop)
	yield(sound, "finished")
	queue_free()


func _on_RunTimer_timeout():
	state = "walking"
	running = false
