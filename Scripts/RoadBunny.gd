extends KinematicBody2D

var health = 30
var direction = 1
var hit_sounds = []
var died = false
var velocity = -2.5
var state = "not dead"
var g_texture_width

onready var animationplayer = $AnimationPlayer
onready var sound = $Sound
onready var damageplayer = $DamagePlayer

func _ready():
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit.wav"))
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit02.wav"))
	hit_sounds.append(preload("res://audio/sounds/Rabbit/rabbit_hit03.wav"))
	g_texture_width = $Sprite.texture.get_size().x * scale.x

func take_damage(damage):
	damageplayer.play("damage")
	if state != "dead":
		state = "dead"
		play_sound(hit_sounds)
		die()

func _physics_process(delta):
	if (health <= 0 && state != "dead"):
		state = "dead"
		die()
	
	if position.x < -g_texture_width - 200:
		queue_free()
	
	match state:
		"not dead":
			position.x += velocity
		"dead":
			pass

func get_player():
	return get_tree().get_nodes_in_group("Player")[0]

func play_sound(sounds):
	randomize()
	sounds.shuffle()
	sound.stream = sounds.front()
	sound.play()

func turn_around():
	scale.x = -scale.x
	direction = -direction

func assign_anim(anim):
	if animationplayer.assigned_animation != anim:
		animationplayer.play(anim)

func die():
	$HurtBox/CollisionShape2D.disabled = true
	yield(sound, "finished")
	queue_free()

func scare():
	turn_around()
	animationplayer.play("scared")
	play_sound(hit_sounds)
