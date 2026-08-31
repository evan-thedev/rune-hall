extends CharacterBody3D

const SPEED = 7.0
const MOUSE_SENSITIVITY = 0.003
const PROJECTILE_SPELL = preload("res://scenes/projectile_spell.tscn")
const CONE_SPELL = preload("res://scenes/cone_spell.tscn")
const TRAP_SPELL = preload("res://scenes/trap_spell.tscn")
const MUZZLE_FLASH = preload("res://scenes/muzzle_flash.tscn")

@onready var camera = $Camera3D
@onready var viewmodel = $Camera3D/Viewmodel

var max_health = 100.0
var health = 100.0
var is_dead = false
var spell_cooldown = 0.5
var last_spell_time = -999.0
var current_spell = 1
var was_moving = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	update_hud()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("cast_spell_1"):
		current_spell = 1
		update_spell_hud()
	elif event.is_action_pressed("cast_spell_2"):
		current_spell = 2
		update_spell_hud()
	elif event.is_action_pressed("cast_spell_3"):
		current_spell = 3
		update_spell_hud()

func _physics_process(delta):
	if is_dead:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var is_moving = direction.length() > 0
	if is_moving != was_moving:
		was_moving = is_moving
		if viewmodel:
			viewmodel.set_walking(is_moving)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cast_spell()

func cast_spell():
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_spell_time < spell_cooldown:
		return
	
	last_spell_time = current_time
	
	spawn_muzzle_flash()
	
	if viewmodel:
		viewmodel.cast_spell(current_spell)
	
	if current_spell == 1:
		cast_projectile()
	elif current_spell == 2:
		cast_cone()
	elif current_spell == 3:
		cast_trap()

func spawn_muzzle_flash():
	var flash = MUZZLE_FLASH.instantiate()
	camera.add_child(flash)
	flash.position = Vector3(0, 0, -0.5)

func cast_projectile():
	var projectile = PROJECTILE_SPELL.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = camera.global_position + camera.global_transform.basis.z * -0.5
	projectile.set_direction(-camera.global_transform.basis.z)

func cast_cone():
	var cone = CONE_SPELL.instantiate()
	get_tree().root.add_child(cone)
	cone.global_position = camera.global_position + camera.global_transform.basis.z * -2.0
	cone.global_rotation = camera.global_rotation
	cone.set_direction(-camera.global_transform.basis.z, camera.global_position)

func cast_trap():
	var space_state = get_world_3d().direct_space_state
	var ray_origin = camera.global_position
	var ray_end = ray_origin + camera.global_transform.basis.z * -5.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if result:
		var trap = TRAP_SPELL.instantiate()
		get_tree().root.add_child(trap)
		trap.global_position = result.position + Vector3(0, 0.1, 0)

func take_damage(amount: float):
	if is_dead:
		return
	
	health -= amount
	health = max(0, health)
	update_hud()
	
	if health <= 0:
		die()

func die():
	is_dead = true
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

func update_hud():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.update_health(health, max_health)

func update_spell_hud():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.update_spell(current_spell)
