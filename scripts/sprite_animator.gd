extends Sprite3D

@export var frames: int = 6
@export var fps: float = 8.0
@export var hframes: int = 6

var current_frame: int = 0
var time_accumulator: float = 0.0
var is_playing: bool = true

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
