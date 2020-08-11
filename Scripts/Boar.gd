extends KinematicBody2D

var health = 100
var walk_speed = 1 * Globals.UNIT_SIZE
var run_speed = 4 * Globals.UNIT_SIZE
var gravity = 563.2
var state = "walking"
var direction = 1
var velocity = Vector2()
var speed
export var damage = 10

onready var turnrays = $TurnRays
onready var vision = $Vision
onready var chasetimer = $ChaseTimer
onready var attacktimer = $AttackTimer
onready var animationplayer = $AnimationPlayer

func take_damage(damage):
	health -= damage
	print(health)

func _physics_process(delta):
	if (health == 0):
		die()
		
	velocity.y += gravity * delta
	
	match state:
		"walking":
			$Hitbox/CollisionShape2D.disabled = true
			speed = walk_speed
			if(check_turn(true)):
				turn_around()
		"chasing":
			$Hitbox/CollisionShape2D.disabled = true
			if(check_turn(false)):
				turn_around()
			turn_to_player()
			speed = run_speed
		"attack":
			if (attacktimer.is_stopped()):
				$Hitbox/CollisionShape2D.disabled = false
				speed = 0
				velocity.x = 0
				var t = Timer.new()
				t.set_wait_time(.5)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				animationplayer.play("attack")
				t.start()
				yield(t, "timeout")
				attacktimer.start()
			state = "chasing"
	
	velocity.x = lerp(velocity.x, speed * direction, 0.4)
	velocity = move_and_slide(velocity, Vector2.UP)

func turn_to_player():
	var player = get_owner().get_node("Player")
	var turndirection = position.direction_to(player.position)
	if turndirection.x > 0:
		if direction != 1:
			turn_around()
	else:
		if direction != -1:
			turn_around()

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
	turn_to_player()

func die():
	queue_free()

func _on_Hitbox_area_entered(area):
	area.take_damage(damage)

func _on_AttackRange_body_entered(body):
	if(body.name == "Player" && state == "chasing"):
		state = "attack"
		chasetimer.stop()
