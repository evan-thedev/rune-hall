extends Node

# Helper to generate collision shapes from mesh instances

static func create_convex_shape_from_mesh(mesh_instance: MeshInstance3D) -> ConvexPolygonShape3D:
	if not mesh_instance or not mesh_instance.mesh:
		return null
	
	var shape = mesh_instance.mesh.create_convex_shape()
	return shape

static func create_trimesh_shape_from_mesh(mesh_instance: MeshInstance3D) -> ConcavePolygonShape3D:
	if not mesh_instance or not mesh_instance.mesh:
		return null
	
	var shape = mesh_instance.mesh.create_trimesh_shape()
	return shape

static func find_all_mesh_instances(node: Node) -> Array[MeshInstance3D]:
	var meshes: Array[MeshInstance3D] = []
	if node is MeshInstance3D:
		meshes.append(node)
	for child in node.get_children():
		meshes.append_array(find_all_mesh_instances(child))
	return meshes

static func create_combined_convex_shape(root: Node) -> ConvexPolygonShape3D:
	var meshes = find_all_mesh_instances(root)
	if meshes.is_empty():
		return null
	
	var all_points: PackedVector3Array = []
	for mesh_inst in meshes:
		if mesh_inst.mesh:
			var arrays = mesh_inst.mesh.surface_get_arrays(0)
			if arrays and arrays.size() > 0:
				var vertices = arrays[Mesh.ARRAY_VERTEX]
				if vertices:
					# Transform vertices to world space
					var transform = mesh_inst.global_transform
					for vertex in vertices:
						all_points.append(transform * vertex)
	
	if all_points.is_empty():
		return null
	
	var shape = ConvexPolygonShape3D.new()
	shape.points = all_points
	return shape
