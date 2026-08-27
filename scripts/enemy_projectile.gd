extends Area3D

const SPEED = 10.0
const LIFETIME = 5.0

var direction = Vector3.FORWARD
var damage = 10.0
var time_alive = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	collision_layer = 4
	collision_mask = 1

func _physics_process(delta):
	global_position += direction * SPEED * delta
	time_alive += delta
	
	if time_alive > LIFETIME:
		queue_free()

func set_direction(dir: Vector3):
	direction = dir.normalized()

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
	elif not body.is_in_group("enemy"):
		queue_free()
