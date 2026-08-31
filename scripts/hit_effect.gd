extends Node3D

const EFFECT_DURATION = 0.5

func _ready():
	$Particles.emitting = true
	
	var tween = create_tween()
	tween.tween_property($Light, "light_energy", 0.0, EFFECT_DURATION)
	
	await get_tree().create_timer(EFFECT_DURATION).timeout
	queue_free()
