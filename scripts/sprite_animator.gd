extends Sprite3D

@export var frames: int = 6
@export var fps: float = 8.0
@export var hframes: int = 6

var current_frame: int = 0
var time_accumulator: float = 0.0
var is_playing: bool = true
var current_front_texture: Texture2D
var current_side_texture: Texture2D

func _ready():
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	hframes = frames
	
func _process(delta):
	if not is_playing:
		return
		
	time_accumulator += delta
	var frame_time = 1.0 / fps
	
	if time_accumulator >= frame_time:
		time_accumulator -= frame_time
		current_frame = (current_frame + 1) % frames
		frame = current_frame

func play():
	is_playing = true
	current_frame = 0
	frame = 0
	
func stop():
	is_playing = false
	
func set_texture_and_play(new_texture: Texture2D):
	texture = new_texture
	play()

func set_textures(front_tex: Texture2D, side_tex: Texture2D):
	current_front_texture = front_tex
	current_side_texture = side_tex

func update_sprite_for_camera(enemy_position: Vector3, camera_position: Vector3, enemy_forward: Vector3):
	if not current_front_texture or not current_side_texture:
		return
	
	var to_camera = (camera_position - enemy_position).normalized()
	to_camera.y = 0
	
	var forward_flat = enemy_forward
	forward_flat.y = 0
	forward_flat = forward_flat.normalized()
	
	var dot = forward_flat.dot(to_camera)
	var cross = forward_flat.cross(to_camera).y
	
	# Front view: camera looking at front or back
	# Side view: camera looking at sides
	if abs(dot) > 0.5:
		texture = current_front_texture
		flip_h = false
	else:
		texture = current_side_texture
		# Flip when viewed from left side
		flip_h = cross > 0
