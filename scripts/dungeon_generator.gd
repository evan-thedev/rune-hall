extends Node3D

const ROOM_SIZE = 10.0
const CORRIDOR_WIDTH = 4.0
const WALL_HEIGHT = 4.0

func _ready():
	generate_dungeon()

func generate_dungeon():
	var room_positions = [
		Vector3(0, 0, 0),
		Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, 0),
		Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, ROOM_SIZE + CORRIDOR_WIDTH),
		Vector3(0, 0, ROOM_SIZE + CORRIDOR_WIDTH),
	]
	
	for pos in room_positions:
		create_room(pos)
	
	create_corridor(Vector3(ROOM_SIZE, 0, 0), Vector3(1, 0, 0), CORRIDOR_WIDTH)
	create_corridor(Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, ROOM_SIZE), Vector3(0, 0, 1), CORRIDOR_WIDTH)
	create_corridor(Vector3(ROOM_SIZE, 0, ROOM_SIZE + CORRIDOR_WIDTH), Vector3(-1, 0, 0), CORRIDOR_WIDTH)
	create_corridor(Vector3(0, 0, ROOM_SIZE), Vector3(0, 0, -1), CORRIDOR_WIDTH)

func create_room(pos: Vector3):
	var floor_mesh = CSGBox3D.new()
	floor_mesh.size = Vector3(ROOM_SIZE, 0.5, ROOM_SIZE)
	floor_mesh.position = pos + Vector3(ROOM_SIZE/2, -0.25, ROOM_SIZE/2)
	floor_mesh.use_collision = true
	add_child(floor_mesh)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.3, 0.35)
	floor_mesh.material = mat
	
	create_walls(pos)
	add_lighting(pos + Vector3(ROOM_SIZE/2, WALL_HEIGHT - 0.5, ROOM_SIZE/2))

func create_walls(room_pos: Vector3):
	var wall_thickness = 0.5
	
	var wall_positions = [
		Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, -wall_thickness/2),
		Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, ROOM_SIZE + wall_thickness/2),
		Vector3(-wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2),
		Vector3(ROOM_SIZE + wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2),
	]
	
	var wall_sizes = [
		Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness),
		Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness),
		Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE),
		Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE),
	]
	
	for i in range(wall_positions.size()):
		var wall = CSGBox3D.new()
		wall.size = wall_sizes[i]
		wall.position = room_pos + wall_positions[i]
		wall.use_collision = true
		add_child(wall)
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.4, 0.35, 0.3)
		wall.material = mat

func create_corridor(start_pos: Vector3, direction: Vector3, length: float):
	var floor_mesh = CSGBox3D.new()
	floor_mesh.size = Vector3(abs(direction.x) * length + (1 - abs(direction.x)) * CORRIDOR_WIDTH,
	                          0.5,
	                          abs(direction.z) * length + (1 - abs(direction.z)) * CORRIDOR_WIDTH)
	floor_mesh.position = start_pos + direction * length/2 + Vector3(0, -0.25, 0)
	floor_mesh.use_collision = true
	add_child(floor_mesh)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.25, 0.3)
	floor_mesh.material = mat

func add_lighting(pos: Vector3):
	var light = OmniLight3D.new()
	light.position = pos
	light.light_energy = 0.8
	light.light_color = Color(1.0, 0.9, 0.7)
	light.omni_range = 15.0
	add_child(light)
