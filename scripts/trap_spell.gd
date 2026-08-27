extends Area3D

const DAMAGE = 30.0
const LIFETIME = 10.0
const ARM_TIME = 0.3

var time_alive = 0.0
var is_armed = false
var triggered_enemies = []

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	time_alive += delta
	
	if time_alive >= ARM_TIME and not is_armed:
		is_armed = true
	
	if time_alive > LIFETIME:
		queue_free()

func _on_body_entered(body):
	if not is_armed:
		return
	
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		if body not in triggered_enemies:
			triggered_enemies.append(body)
			body.take_damage(DAMAGE)
			queue_free()

func _on_area_entered(area):
	if not is_armed:
		return
	
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy and enemy.has_method("take_damage"):
			if enemy not in triggered_enemies:
				triggered_enemies.append(enemy)
				enemy.take_damage(DAMAGE)
				queue_free()
