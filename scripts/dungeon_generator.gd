extends Node3D

const ROOM_SIZE = 10.0
const CORRIDOR_WIDTH = 4.0
const WALL_HEIGHT = 4.0
const ENEMY_BASIC = preload("res://scenes/enemy_basic.tscn")

func _ready():
	generate_dungeon()

func generate_dungeon():
	var room_positions = [
		Vector3(0, 0, 0),
		Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, 0),
		Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, ROOM_SIZE + CORRIDOR_WIDTH),
		Vector3(0, 0, ROOM_SIZE + CORRIDOR_WIDTH),
	]
	
	var door_configs = [
		{"north": false, "south": true, "east": true, "west": false},
		{"north": false, "south": true, "east": false, "west": true},
		{"north": true, "south": false, "east": false, "west": true},
		{"north": true, "south": false, "east": true, "west": false},
	]
	
	for i in range(room_positions.size()):
		create_room(room_positions[i], door_configs[i])
	
	create_corridor(Vector3(ROOM_SIZE, 0, ROOM_SIZE/2), Vector3(1, 0, 0), CORRIDOR_WIDTH)
	create_corridor(Vector3(ROOM_SIZE + CORRIDOR_WIDTH + ROOM_SIZE/2, 0, ROOM_SIZE), Vector3(0, 0, 1), CORRIDOR_WIDTH)
	create_corridor(Vector3(ROOM_SIZE + CORRIDOR_WIDTH, 0, ROOM_SIZE + CORRIDOR_WIDTH + ROOM_SIZE/2), Vector3(-1, 0, 0), CORRIDOR_WIDTH)
	create_corridor(Vector3(ROOM_SIZE/2, 0, ROOM_SIZE + CORRIDOR_WIDTH), Vector3(0, 0, -1), CORRIDOR_WIDTH)
	
	spawn_enemies(room_positions)

func create_room(pos: Vector3, doors: Dictionary):
	var floor_mesh = CSGBox3D.new()
	floor_mesh.size = Vector3(ROOM_SIZE, 0.5, ROOM_SIZE)
	floor_mesh.position = pos + Vector3(ROOM_SIZE/2, -0.25, ROOM_SIZE/2)
	floor_mesh.use_collision = true
	add_child(floor_mesh)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.3, 0.35)
	floor_mesh.material = mat
	
	create_walls_with_doors(pos, doors)
	add_lighting(pos + Vector3(ROOM_SIZE/2, WALL_HEIGHT - 0.5, ROOM_SIZE/2))

func create_walls_with_doors(room_pos: Vector3, doors: Dictionary):
	var wall_thickness = 0.5
	var door_width = CORRIDOR_WIDTH
	var wall_segment_size = (ROOM_SIZE - door_width) / 2.0
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.4, 0.35, 0.3)
	
	if not doors.get("north", false):
		var wall = CSGBox3D.new()
		wall.size = Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness)
		wall.position = room_pos + Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, -wall_thickness/2)
		wall.use_collision = true
		wall.material = mat
		add_child(wall)
	else:
		create_wall_with_door_opening(room_pos, Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, -wall_thickness/2), 
		                               Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness), true, mat)
	
	if not doors.get("south", false):
		var wall = CSGBox3D.new()
		wall.size = Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness)
		wall.position = room_pos + Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, ROOM_SIZE + wall_thickness/2)
		wall.use_collision = true
		wall.material = mat
		add_child(wall)
	else:
		create_wall_with_door_opening(room_pos, Vector3(ROOM_SIZE/2, WALL_HEIGHT/2, ROOM_SIZE + wall_thickness/2),
		                               Vector3(ROOM_SIZE, WALL_HEIGHT, wall_thickness), true, mat)
	
	if not doors.get("west", false):
		var wall = CSGBox3D.new()
		wall.size = Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE)
		wall.position = room_pos + Vector3(-wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2)
		wall.use_collision = true
		wall.material = mat
		add_child(wall)
	else:
		create_wall_with_door_opening(room_pos, Vector3(-wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2),
		                               Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE), false, mat)
	
	if not doors.get("east", false):
		var wall = CSGBox3D.new()
		wall.size = Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE)
		wall.position = room_pos + Vector3(ROOM_SIZE + wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2)
		wall.use_collision = true
		wall.material = mat
		add_child(wall)
	else:
		create_wall_with_door_opening(room_pos, Vector3(ROOM_SIZE + wall_thickness/2, WALL_HEIGHT/2, ROOM_SIZE/2),
		                               Vector3(wall_thickness, WALL_HEIGHT, ROOM_SIZE), false, mat)

func create_wall_with_door_opening(room_pos: Vector3, base_pos: Vector3, base_size: Vector3, 
                                    is_horizontal: bool, mat: StandardMaterial3D):
	var door_width = CORRIDOR_WIDTH
	var wall_thickness = 0.5
	
	if is_horizontal:
		var segment_width = (ROOM_SIZE - door_width) / 2.0
		
		var wall1 = CSGBox3D.new()
		wall1.size = Vector3(segment_width, WALL_HEIGHT, wall_thickness)
		wall1.position = room_pos + Vector3(segment_width/2, WALL_HEIGHT/2, base_pos.z)
		wall1.use_collision = true
		wall1.material = mat
		add_child(wall1)
		
		var wall2 = CSGBox3D.new()
		wall2.size = Vector3(segment_width, WALL_HEIGHT, wall_thickness)
		wall2.position = room_pos + Vector3(ROOM_SIZE - segment_width/2, WALL_HEIGHT/2, base_pos.z)
		wall2.use_collision = true
		wall2.material = mat
		add_child(wall2)
	else:
		var segment_width = (ROOM_SIZE - door_width) / 2.0
		
		var wall1 = CSGBox3D.new()
		wall1.size = Vector3(wall_thickness, WALL_HEIGHT, segment_width)
		wall1.position = room_pos + Vector3(base_pos.x, WALL_HEIGHT/2, segment_width/2)
		wall1.use_collision = true
		wall1.material = mat
		add_child(wall1)
		
		var wall2 = CSGBox3D.new()
		wall2.size = Vector3(wall_thickness, WALL_HEIGHT, segment_width)
		wall2.position = room_pos + Vector3(base_pos.x, WALL_HEIGHT/2, ROOM_SIZE - segment_width/2)
		wall2.use_collision = true
		wall2.material = mat
		add_child(wall2)

func create_corridor(start_pos: Vector3, direction: Vector3, length: float):
	var floor_mesh = CSGBox3D.new()
	floor_mesh.size = Vector3(abs(direction.x) * length + (1 - abs(direction.x)) * CORRIDOR_WIDTH,
	                          0.5,
	                          abs(direction.z) * length + (1 - abs(direction.z)) * CORRIDOR_WIDTH)
	floor_mesh.position = start_pos + direction * length/2 + Vector3(0, -0.25, 0)
	floor_mesh.use_collision = true
	add_child(floor_mesh)
	
	var floor_mat = StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.25, 0.25, 0.3)
	floor_mesh.material = floor_mat
	
	var wall_mat = StandardMaterial3D.new()
	wall_mat.albedo_color = Color(0.4, 0.35, 0.3)
	var wall_thickness = 0.5
	
	if abs(direction.x) > 0:
		var wall1 = CSGBox3D.new()
		wall1.size = Vector3(length, WALL_HEIGHT, wall_thickness)
		wall1.position = start_pos + direction * length/2 + Vector3(0, WALL_HEIGHT/2, -CORRIDOR_WIDTH/2 - wall_thickness/2)
		wall1.use_collision = true
		wall1.material = wall_mat
		add_child(wall1)
		
		var wall2 = CSGBox3D.new()
		wall2.size = Vector3(length, WALL_HEIGHT, wall_thickness)
		wall2.position = start_pos + direction * length/2 + Vector3(0, WALL_HEIGHT/2, CORRIDOR_WIDTH/2 + wall_thickness/2)
		wall2.use_collision = true
		wall2.material = wall_mat
		add_child(wall2)
	else:
		var wall1 = CSGBox3D.new()
		wall1.size = Vector3(wall_thickness, WALL_HEIGHT, length)
		wall1.position = start_pos + direction * length/2 + Vector3(-CORRIDOR_WIDTH/2 - wall_thickness/2, WALL_HEIGHT/2, 0)
		wall1.use_collision = true
		wall1.material = wall_mat
		add_child(wall1)
		
		var wall2 = CSGBox3D.new()
		wall2.size = Vector3(wall_thickness, WALL_HEIGHT, length)
		wall2.position = start_pos + direction * length/2 + Vector3(CORRIDOR_WIDTH/2 + wall_thickness/2, WALL_HEIGHT/2, 0)
		wall2.use_collision = true
		wall2.material = wall_mat
		add_child(wall2)

func add_lighting(pos: Vector3):
	var light = OmniLight3D.new()
	light.position = pos
	light.light_energy = 0.8
	light.light_color = Color(1.0, 0.9, 0.7)
	light.omni_range = 15.0
	add_child(light)

func spawn_enemies(room_positions: Array):
	for i in range(1, room_positions.size()):
		var room_center = room_positions[i] + Vector3(ROOM_SIZE/2, 1, ROOM_SIZE/2)
		
		var num_enemies = randi() % 2 + 1
		for j in range(num_enemies):
			var offset = Vector3(randf_range(-3, 3), 0, randf_range(-3, 3))
			var enemy_pos = room_center + offset
			
			var enemy = ENEMY_BASIC.instantiate()
			add_child(enemy)
			enemy.global_position = enemy_pos
