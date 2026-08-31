extends Area3D

const SPEED = 20.0
const DAMAGE = 25.0
const LIFETIME = 5.0
const HIT_EFFECT = preload("res://scenes/hit_effect.tscn")

var direction = Vector3.FORWARD
var time_alive = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	global_position += direction * SPEED * delta
	time_alive += delta
	
	if time_alive > LIFETIME:
		queue_free()

func set_direction(dir: Vector3):
	direction = dir.normalized()

func spawn_hit_effect():
	var effect = HIT_EFFECT.instantiate()
	get_tree().root.add_child(effect)
	effect.global_position = global_position

func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(DAMAGE)
	
	spawn_hit_effect()
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage(DAMAGE)
		spawn_hit_effect()
		queue_free()
