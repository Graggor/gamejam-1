extends Control

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween

func _on_health_updated(health):
	update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.1)
	update_tween.start()

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health
