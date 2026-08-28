extends CharacterBody3D

const SPEED = 2.0
const ATTACK_RANGE = 15.0
const MIN_RANGE = 8.0
const ATTACK_DAMAGE = 10.0
const ATTACK_COOLDOWN = 2.0

var max_health = 1.0
var health = 1.0
var player = null
var last_attack_time = -999.0
var is_dead = false

const ENEMY_PROJECTILE = preload("res://scenes/enemy_projectile.tscn")

@onready var mesh_animator = $GoblinMesh

func _ready():
	add_to_group("enemy")
	mesh_animator.set_state(mesh_animator.AnimState.IDLE)

func _physics_process(delta):
	if is_dead:
		return
	
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player > ATTACK_RANGE:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		mesh_animator.set_state(mesh_animator.AnimState.WALK, direction)
	elif distance_to_player < MIN_RANGE:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
		mesh_animator.set_state(mesh_animator.AnimState.WALK, -direction)
	else:
		velocity.x = 0
		velocity.z = 0
		if try_attack():
			mesh_animator.set_state(mesh_animator.AnimState.ATTACK)
		else:
			mesh_animator.set_state(mesh_animator.AnimState.IDLE)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func try_attack() -> bool:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_attack_time < ATTACK_COOLDOWN:
		return false
	
	last_attack_time = current_time
	shoot_projectile()
	return true

func shoot_projectile():
	var projectile = ENEMY_PROJECTILE.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = global_position + Vector3(0, 1, 0)
	
	var direction_to_player = (player.global_position - global_position).normalized()
	projectile.set_direction(direction_to_player)
	projectile.damage = ATTACK_DAMAGE

func take_damage(amount: float):
	if is_dead:
		return
	
	health -= amount
	if health <= 0:
		die()

func die():
	is_dead = true
	mesh_animator.set_state(mesh_animator.AnimState.DEATH)
	# Wait for death animation (coin spill) before removing
	await get_tree().create_timer(1.0).timeout
	queue_free()
