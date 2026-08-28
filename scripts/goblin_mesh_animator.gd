extends Node3D

# Goblin 3D mesh animator with simple transform-based animations
@export var idle_bob_speed: float = 2.0
@export var idle_bob_amount: float = 0.05
@export var walk_bob_speed: float = 8.0
@export var walk_bob_amount: float = 0.15

enum AnimState { IDLE, WALK, ATTACK, FLINCH, DEATH }

var current_state = AnimState.IDLE
var time_accumulator: float = 0.0
var animation_locked: bool = false
var lock_timer: float = 0.0
var base_y_position: float = 0.0
var walk_direction: Vector3 = Vector3.ZERO

@onready var mesh_root = self

func _ready():
	base_y_position = position.y

func _process(delta):
	time_accumulator += delta
	
	# Handle locked animation timers
	if animation_locked:
		lock_timer -= delta
		if lock_timer <= 0:
			animation_locked = false
			set_state(AnimState.IDLE)
	
	# Apply animations based on state
	match current_state:
		AnimState.IDLE:
			_animate_idle(delta)
		AnimState.WALK:
			_animate_walk(delta)
		AnimState.ATTACK:
			_animate_attack(delta)
		AnimState.FLINCH:
			_animate_flinch(delta)
		AnimState.DEATH:
			_animate_death(delta)

func set_state(new_state: AnimState, direction: Vector3 = Vector3.ZERO):
	# Don't interrupt locked animations
	if animation_locked and new_state in [AnimState.IDLE, AnimState.WALK]:
		return
	
	if current_state == new_state and direction.is_equal_approx(walk_direction):
		return
	
	current_state = new_state
	walk_direction = direction
	time_accumulator = 0.0
	
	# Reset mesh to base position/rotation
	position.y = base_y_position
	rotation = Vector3.ZERO
	scale = Vector3.ONE
	
	# Face the movement direction for walking
	if new_state == AnimState.WALK and direction.length() > 0.1:
		var target_angle = atan2(direction.x, direction.z)
		rotation.y = target_angle
	
	# Lock animations that should play once
	match new_state:
		AnimState.ATTACK:
			animation_locked = true
			lock_timer = 0.5
		AnimState.FLINCH:
			animation_locked = true
			lock_timer = 0.3
		AnimState.DEATH:
			animation_locked = true

func _animate_idle(_delta):
	# Gentle bobbing
	var bob = sin(time_accumulator * idle_bob_speed) * idle_bob_amount
	position.y = base_y_position + bob

func _animate_walk(_delta):
	# Walking bob
	var bob = abs(sin(time_accumulator * walk_bob_speed)) * walk_bob_amount
	position.y = base_y_position + bob
	
	# Slight side-to-side sway
	var sway = sin(time_accumulator * walk_bob_speed) * 0.05
	rotation.z = sway

func _animate_attack(_delta):
	# Quick forward lunge
	var progress = min(time_accumulator / 0.5, 1.0)
	if progress < 0.5:
		# Lunge forward
		scale.z = 1.0 + progress * 0.4
	else:
		# Return
		scale.z = 1.0 + (1.0 - progress) * 0.4

func _animate_flinch(_delta):
	# Recoil back
	var progress = min(time_accumulator / 0.3, 1.0)
	scale.x = 1.0 - progress * 0.2
	scale.y = 1.0 + progress * 0.1

func _animate_death(_delta):
	# Fall and shrink
	var progress = min(time_accumulator / 1.0, 1.0)
	rotation.x = progress * PI / 2
	scale = Vector3.ONE * (1.0 - progress * 0.5)
	position.y = base_y_position - progress * 0.8
