extends KinematicBody2D

var health = 37
var walk_speed = 1 * Globals.UNIT_SIZE
var run_speed = 6 * Globals.UNIT_SIZE
var attack_speed = 12 * Globals.UNIT_SIZE
var gravity = 563.2
var state = "walking"
var direction = 1
var velocity = Vector2()
var speed
export var damage = 10
var attack_range = 60
var chase_range = 90
var attacking = false
var may_attack = true
var meat = preload("res://Levels/Pickups/Meat.tscn")
var running_back = false

signal mammoth_died()

onready var turnrays = $TurnRays
onready var vision = $Vision
onready var chasetimer = $ChaseTimer
onready var attacktimer = $AttackTimer
onready var attackcooldown = $AttackCooldown
onready var animationplayer = $AnimationPlayer
onready var attackvision = $AttackRange
onready var sound = $Sound
onready var sound2 = $Sound2
onready var get_hit_sound = preload("res://audio/sounds/Mammoth/mammoth_attacked.wav")
onready var damageplayer = $DamagePlayer

func take_damage(damage_taken):
	damageplayer.play("damage")
	health -= damage_taken
	sound2.stop()
	sound2.stream = get_hit_sound
	sound2.play(0.2)

func _physics_process(delta):
	if (health <= 0):
		die()
	
	velocity.y += gravity * delta
	
	match state:
		"walking":
			attacking = false
			animationplayer.play("walk")
			speed = walk_speed
			if(check_turn(true)):
				turn_around()
			velocity.x = lerp(velocity.x, speed * direction, 0.4)
			velocity = move_and_slide(velocity, Vector2.UP)
		"chasing":
			attacking = false
			animationplayer.play("run_angry")
			if(check_turn(false)):
				turn_around()
			turn_to_player()
			speed = run_speed
			if close_to_player():
				speed = 0.5 * run_speed
			velocity.x = lerp(velocity.x, speed * direction, 0.4)
			velocity = move_and_slide(velocity, Vector2.UP)
			if can_attack():
				state = "attack"
		"attack":
			if(check_turn(false)):
				turn_around()
			if is_on_floor() && !attacking:
				attacking = true
				speed = 0
				animationplayer.play("attack_charge")
				yield(animationplayer, "animation_finished")
				$Hitbox/Hitbox.disabled = false
				animationplayer.play("run_angry")
				speed = attack_speed
				$Hitbox/Hitbox.disabled = false
				attacktimer.start()
			velocity.x = lerp(velocity.x, speed * direction, 0.4)
			velocity = move_and_slide(velocity, Vector2.UP)
		"dead":
			attacking = false
			pass
		"attack_hit":
			animationplayer.play("attack_hit")
			yield(animationplayer, "animation_finished")
			state = "chasing"

func turn_to_player():
	var player = get_player()
	var turndirection = position.direction_to(player.global_position)
	if turndirection.x > 0:
		if direction != 1:
			turn_around()
	else:
		if direction != -1:
			turn_around()
	
func can_attack():
	var player = get_player()
	if attackvision.overlaps_body(player) && attackcooldown.is_stopped():
		return true
	return false

func close_to_player():
	var player = get_player()
	var to_player = player.global_position.x - global_position.x
	var distance = max(to_player, -to_player)
	if (distance <= chase_range):
		return true
	return false

func get_player():
	return get_tree().get_nodes_in_group("Player")[0]
	
func _on_Vision_body_entered(body):
	if(body.name == "Player" && state == "walking"):
		state = "chasing"
		chasetimer.start()

func check_turn(check_floor):
	if $TurnRays/Wall.is_colliding():
		return true
	if !$TurnRays/Floor.is_colliding() && check_floor:
		return true
	return false

func turn_around():
	scale.x = -scale.x
	direction = -direction


func _on_ChaseTimer_timeout():
	if state != "attack" && state != "walking":
		turn_to_player()

func die():
	var drop = meat.instance()
	drop.position = position
	get_parent().add_child(drop)
	emit_signal("mammoth_died")
	queue_free()

func _on_Hitbox_area_entered(area):
	state = "attack_hit"
	area.take_damage(damage)

func _on_AttackRange_body_entered(body):
	if(body.name == "Player" && state == "chasing"):
		state = "attack"
		chasetimer.stop()


func _on_AttackTimer_timeout():
	$Hitbox/Hitbox.disabled = true
	attacking = false
	attackcooldown.start()
	state = "chasing"


func _on_AttackCooldown_timeout():
	may_attack = true


func _on_Aggro_body_exited(_body):
	state = "walking"
