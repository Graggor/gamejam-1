extends Sprite

export var velocity = -2.5
var g_texture_width

func _ready():
	g_texture_width = texture.get_size().x * scale.x

func _process(delta):
	position.x += velocity
	_attempt_reposition()

func _attempt_reposition():
	if position.x < -g_texture_width - 200:
		position.x += 2 * g_texture_width

