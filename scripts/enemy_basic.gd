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

@onready var sprite = $Sprite3D
var idle_texture: Texture2D
var walk_texture: Texture2D
var attack_texture: Texture2D

enum State { IDLE, WALK, ATTACK }
var current_state = State.IDLE

func _ready():
	add_to_group("enemy")
	idle_texture = preload("res://sprites/grunt_idle_front.png")
	walk_texture = preload("res://sprites/grunt_walk_front.png")
	attack_texture = preload("res://sprites/grunt_attack_front.png")
	set_state(State.IDLE)

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
		set_state(State.WALK)
	else:
		velocity.x = 0
		velocity.z = 0
		if try_attack():
			set_state(State.ATTACK)
		else:
			set_state(State.IDLE)
	
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

func set_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.IDLE:
			sprite.set_texture_and_play(idle_texture)
		State.WALK:
			sprite.set_texture_and_play(walk_texture)
		State.ATTACK:
			sprite.set_texture_and_play(attack_texture)

func take_damage(amount: float):
	if is_dead:
		return
	
	health -= amount
	health = max(0, health)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	queue_free()
