extends Control

onready var hunger_bar = $HungerBar
onready var update_tween = $UpdateTween

func _on_hunger_updated(hunger):
	update_tween.interpolate_property(hunger_bar, "value", hunger_bar.value, hunger, 0.1)
	update_tween.start()

func _on_max_hunger_updated(max_hunger):
	hunger_bar.max_value = max_hunger
