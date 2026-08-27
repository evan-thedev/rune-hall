extends Sprite3D

# Goblin sprite animator with full directional support
@export var fps: float = 8.0
@export var hframes_walk: int = 6
@export var hframes_idle: int = 1
@export var hframes_attack: int = 5
@export var hframes_flinch: int = 1
@export var hframes_death: int = 6

var current_frame: int = 0
var time_accumulator: float = 0.0
var is_playing: bool = true
var current_frames: int = 1

# Textures for each state and direction
var idle_texture: Texture2D
var walk_front_texture: Texture2D
var walk_back_texture: Texture2D
var walk_left_texture: Texture2D
var walk_right_texture: Texture2D
var attack_texture: Texture2D
var flinch_texture: Texture2D
var death_texture: Texture2D

enum AnimState { IDLE, WALK, ATTACK, FLINCH, DEATH }
var current_state = AnimState.IDLE
var walk_direction: Vector3 = Vector3.ZERO

func _ready():
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	
func _process(delta):
	if not is_playing:
		return
		
	time_accumulator += delta
	var frame_time = 1.0 / fps
	
	if time_accumulator >= frame_time and current_frames > 1:
		time_accumulator -= frame_time
		current_frame = (current_frame + 1) % current_frames
		frame = current_frame

func set_state(new_state: AnimState, direction: Vector3 = Vector3.ZERO):
	if current_state == new_state and direction.is_equal_approx(walk_direction):
		return
	
	current_state = new_state
	walk_direction = direction
	current_frame = 0
	frame = 0
	time_accumulator = 0.0
	is_playing = true
	
	match current_state:
		AnimState.IDLE:
			texture = idle_texture
			hframes = hframes_idle
			current_frames = hframes_idle
		AnimState.WALK:
			_set_walk_texture(direction)
			hframes = hframes_walk
			current_frames = hframes_walk
		AnimState.ATTACK:
			texture = attack_texture
			hframes = hframes_attack
			current_frames = hframes_attack
		AnimState.FLINCH:
			texture = flinch_texture
			hframes = hframes_flinch
			current_frames = hframes_flinch
		AnimState.DEATH:
			texture = death_texture
			hframes = hframes_death
			current_frames = hframes_death
			is_playing = true

func _set_walk_texture(direction: Vector3):
	# Choose walk sprite based on movement direction
	if direction.length() < 0.1:
		texture = walk_front_texture
		return
	
	# Determine primary direction
	var abs_x = abs(direction.x)
	var abs_z = abs(direction.z)
	
	if abs_z > abs_x:
		# Moving primarily forward/back
		if direction.z < 0:
			texture = walk_front_texture  # Moving toward camera
		else:
			texture = walk_back_texture   # Moving away from camera
	else:
		# Moving primarily left/right
		if direction.x < 0:
			texture = walk_left_texture
		else:
			texture = walk_right_texture
