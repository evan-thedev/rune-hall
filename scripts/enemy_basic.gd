extends CharacterBody3D

const SPEED = 3.0
const ATTACK_RANGE = 2.5
const ATTACK_DAMAGE = 15.0
const ATTACK_COOLDOWN = 1.5

var max_health = 50.0
var health = 50.0
var player = null
var last_attack_time = -999.0
var is_dead = false

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
	if player and player.has_method("take_damage"):
		player.take_damage(ATTACK_DAMAGE)
	return true

func take_damage(amount: float):
	if is_dead:
		return
	
	health -= amount
	health = max(0, health)
	
	# Show flinch animation
	if health > 0:
		mesh_animator.set_state(mesh_animator.AnimState.FLINCH)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	mesh_animator.set_state(mesh_animator.AnimState.DEATH)
	# Wait for death animation before removing
	await get_tree().create_timer(1.0).timeout
	queue_free()
