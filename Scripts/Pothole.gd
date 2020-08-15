extends Node2D

var velocity = -2.5
var g_texture_width
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	g_texture_width = $Sprite.texture.get_size().x * scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += velocity
	if position.x < -g_texture_width - 200:
		queue_free()


func _on_Pothole_area_entered(area):
	area.take_damage(20)
