extends Node3D

# Goblin 3D mesh animator - GLBs have Standing and Death mesh nodes

enum AnimState { IDLE, WALK, ATTACK, FLINCH, DEATH }

var current_state = AnimState.IDLE
var standing_mesh: Node3D = null
var death_mesh: Node3D = null
var is_dying: bool = false

func _ready():
	# Find Standing and Death mesh nodes inside GoblinModel
	var model = get_node_or_null("GoblinModel")
	if model:
		standing_mesh = _find_node_by_name(model, "Standing")
		death_mesh = _find_node_by_name(model, "Death")
		
		# Show Standing, hide Death on spawn
		if standing_mesh:
			standing_mesh.visible = true
		if death_mesh:
			death_mesh.visible = false
		
		# Fix vertex colors for all mesh materials
		_fix_vertex_colors(model)

func _find_node_by_name(node: Node, target_name: String) -> Node3D:
	# Search for node by name in the GLB instance
	if node.name == target_name:
		return node
	for child in node.get_children():
		var result = _find_node_by_name(child, target_name)
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
	
	# Handle Death by showing Death mesh, hiding Standing mesh
	if new_state == AnimState.DEATH:
		is_dying = true
		if standing_mesh:
			standing_mesh.visible = false
		if death_mesh:
			death_mesh.visible = true
		return
	
	# Face the movement direction for walking
	if new_state == AnimState.WALK and direction.length() > 0.1:
		var target_angle = atan2(direction.x, direction.z)
		rotation.y = target_angle
