extends CharacterBody3D

const SPEED = 2.0
const ATTACK_RANGE = 15.0
const MIN_RANGE = 8.0
const ATTACK_DAMAGE = 10.0
const ATTACK_COOLDOWN = 2.0

var max_health = 30.0
var health = 30.0
var player = null
var last_attack_time = -999.0
var is_dead = false

const ENEMY_PROJECTILE = preload("res://scenes/enemy_projectile.tscn")

@onready var sprite = $Sprite3D

func _ready():
	add_to_group("enemy")
	
	# Load all loot goblin sprites
	sprite.idle_texture = preload("res://sprites/loot-goblin-idle.png")
	sprite.walk_front_texture = preload("res://sprites/loot-goblin-walk-front.png")
	sprite.walk_back_texture = preload("res://sprites/loot-goblin-walk-back.png")
	sprite.walk_left_texture = preload("res://sprites/loot-goblin-walk-left.png")
	sprite.walk_right_texture = preload("res://sprites/loot-goblin-walk-right.png")
	sprite.attack_texture = preload("res://sprites/loot-goblin-attack.png")
	sprite.flinch_texture = preload("res://sprites/loot-goblin-flinch.png")
	sprite.death_texture = preload("res://sprites/loot-goblin-death.png")
	
	sprite.set_state(sprite.AnimState.IDLE)

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
		sprite.set_state(sprite.AnimState.WALK, direction)
	elif distance_to_player < MIN_RANGE:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
		sprite.set_state(sprite.AnimState.WALK, -direction)
	else:
		velocity.x = 0
		velocity.z = 0
		if try_attack():
			sprite.set_state(sprite.AnimState.ATTACK)
		else:
			sprite.set_state(sprite.AnimState.IDLE)
	
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
	health = max(0, health)
	
	# Show flinch animation
	if health > 0:
		sprite.set_state(sprite.AnimState.FLINCH)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	sprite.set_state(sprite.AnimState.DEATH)
	# Wait for death animation (coin spill) before removing
	await get_tree().create_timer(1.0).timeout
	queue_free()
