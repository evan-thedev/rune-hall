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
@onready var area_collision = $Area3D/CollisionShape3D

func _ready():
	add_to_group("enemy")
	mesh_animator.set_state(mesh_animator.AnimState.IDLE)
	
	# Generate mesh-based hurtbox collision from GLB
	await get_tree().process_frame  # Wait for GLB to load
	_setup_mesh_collision()

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

func _setup_mesh_collision():
	# Generate convex collision from GLB mesh
	var model = mesh_animator.get_node_or_null("GoblinModel")
	if not model:
		return
	
	var mesh_instances = _find_all_mesh_instances(model)
	if mesh_instances.is_empty():
		return
	
	# Create combined convex shape from all mesh instances
	var all_points: PackedVector3Array = []
	for mesh_inst in mesh_instances:
		if mesh_inst.mesh:
			for surface_idx in range(mesh_inst.mesh.get_surface_count()):
				var arrays = mesh_inst.mesh.surface_get_arrays(surface_idx)
				if arrays and arrays.size() > Mesh.ARRAY_VERTEX:
					var vertices = arrays[Mesh.ARRAY_VERTEX]
					if vertices:
						# Transform vertices relative to enemy root
						var local_transform = mesh_animator.transform * mesh_inst.transform
						for vertex in vertices:
							all_points.append(local_transform * vertex)
	
	if not all_points.is_empty():
		var shape = ConvexPolygonShape3D.new()
		shape.points = all_points
		area_collision.shape = shape

func _find_all_mesh_instances(node: Node) -> Array:
	var meshes = []
	if node is MeshInstance3D:
		meshes.append(node)
	for child in node.get_children():
		meshes.append_array(_find_all_mesh_instances(child))
	return meshes

func die():
	is_dead = true
	mesh_animator.set_state(mesh_animator.AnimState.DEATH)
	
	# Wait for GLB Death animation to complete
	var anim_player = mesh_animator.animation_player
	if anim_player and anim_player.has_animation("Death"):
		var death_length = anim_player.get_animation("Death").length
		await get_tree().create_timer(death_length).timeout
	else:
		# Fallback wait time
		await get_tree().create_timer(1.0).timeout
	
	queue_free()
