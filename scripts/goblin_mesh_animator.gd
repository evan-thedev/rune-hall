extends Node3D

# Goblin 3D mesh animator - uses GLB animations from Asset Maker

enum AnimState { IDLE, WALK, ATTACK, FLINCH, DEATH }

var current_state = AnimState.IDLE
var animation_player: AnimationPlayer = null
var is_dying: bool = false

func _ready():
	# Find AnimationPlayer inside the instanced GoblinModel
	var model = get_node_or_null("GoblinModel")
	if model:
		animation_player = _find_animation_player(model)
		if animation_player:
			# Start with Standing animation
			if animation_player.has_animation("Standing"):
				animation_player.play("Standing")
		
		# Fix vertex colors for all mesh materials
		_fix_vertex_colors(model)

func _find_animation_player(node: Node) -> AnimationPlayer:
	# Search for AnimationPlayer in the GLB instance
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var result = _find_animation_player(child)
		if result:
			return result
	return null

func _fix_vertex_colors(node: Node):
	# Walk the mesh tree and enable vertex_color_use_as_albedo
	if node is MeshInstance3D:
		for i in range(node.get_surface_override_material_count()):
			var mat = node.get_surface_override_material(i)
			if mat and mat is StandardMaterial3D:
				mat.vertex_color_use_as_albedo = true
		
		# Also check the main material
		if node.mesh:
			for i in range(node.mesh.get_surface_count()):
				var mat = node.mesh.surface_get_material(i)
				if mat and mat is StandardMaterial3D:
					mat.vertex_color_use_as_albedo = true
	
	for child in node.get_children():
		_fix_vertex_colors(child)

func set_state(new_state: AnimState, direction: Vector3 = Vector3.ZERO):
	# Don't change state if already dying
	if is_dying:
		return
	
	if current_state == new_state:
		return
	
	current_state = new_state
	
	# Handle Death animation from GLB
	if new_state == AnimState.DEATH:
		is_dying = true
		if animation_player and animation_player.has_animation("Death"):
			animation_player.play("Death")
		return
	
	# Face the movement direction for walking
	if new_state == AnimState.WALK and direction.length() > 0.1:
		var target_angle = atan2(direction.x, direction.z)
		rotation.y = target_angle
	
	# Play Standing animation for idle/walk/attack states
	if animation_player and animation_player.has_animation("Standing"):
		if not animation_player.is_playing() or animation_player.current_animation != "Standing":
			animation_player.play("Standing")
