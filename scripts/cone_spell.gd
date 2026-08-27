extends Area3D

const DAMAGE = 15.0
const RANGE = 8.0
const CONE_ANGLE = 45.0
const LIFETIME = 0.3

var caster_position = Vector3.ZERO
var direction = Vector3.FORWARD
var time_alive = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	time_alive += delta
	
	if time_alive > LIFETIME:
		queue_free()

func set_direction(dir: Vector3, pos: Vector3):
	direction = dir.normalized()
	caster_position = pos

func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		if is_in_cone(body.global_position):
			body.take_damage(DAMAGE)

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			if is_in_cone(enemy.global_position):
				enemy.take_damage(DAMAGE)

func is_in_cone(target_pos: Vector3) -> bool:
	var to_target = target_pos - caster_position
	var distance = to_target.length()
	
	if distance > RANGE:
		return false
	
	var angle = rad_to_deg(direction.angle_to(to_target))
	return angle <= CONE_ANGLE
