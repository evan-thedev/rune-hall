extends Node3D

@onready var sprite = $Sprite3D

var idle_frames = []
var walk_frames = []
var cast_fireball_frames = []
var cast_lightning_frames = []
var cast_frosttrap_frames = []

var current_animation = "idle"
var current_frame = 0
var frame_time = 0.0
var frame_duration = 0.1

var is_walking = false
var is_casting = false

const FRAME_COUNT = 6

func _ready():
	load_sprite_frames()
	play_animation("idle")

func load_sprite_frames():
	idle_frames = load_frames_from_sheet("res://sprites/hand-idle.png", FRAME_COUNT)
	walk_frames = load_frames_from_sheet("res://sprites/hand-walk.png", FRAME_COUNT)
	cast_fireball_frames = load_frames_from_sheet("res://sprites/hand-cast-fireball.png", FRAME_COUNT)
	cast_lightning_frames = load_frames_from_sheet("res://sprites/hand-cast-lightning.png", FRAME_COUNT)
	cast_frosttrap_frames = load_frames_from_sheet("res://sprites/hand-cast-frosttrap.png", FRAME_COUNT)

func load_frames_from_sheet(path: String, frame_count: int) -> Array:
	var frames = []
	if ResourceLoader.exists(path):
		var sheet = load(path)
		if sheet:
			var frame_width = sheet.get_width() / frame_count
			for i in range(frame_count):
				var atlas = AtlasTexture.new()
				atlas.atlas = sheet
				atlas.region = Rect2(i * frame_width, 0, frame_width, sheet.get_height())
				frames.append(atlas)
	return frames

func _process(delta):
	var frames = get_current_frames()
	if frames.size() == 0:
		return
	
	frame_time += delta
	if frame_time >= frame_duration:
		frame_time = 0.0
		
		if current_animation == "idle":
			current_frame = 0
		else:
			current_frame = (current_frame + 1) % frames.size()
		
		update_sprite()

func get_current_frames() -> Array:
	match current_animation:
		"idle":
			return idle_frames
		"walk":
			return walk_frames
		"cast_fireball":
			return cast_fireball_frames
		"cast_lightning":
			return cast_lightning_frames
		"cast_frosttrap":
			return cast_frosttrap_frames
	return idle_frames

func update_sprite():
	var frames = get_current_frames()
	if frames.size() > 0 and sprite:
		sprite.texture = frames[current_frame]

func play_animation(anim_name: String):
	current_animation = anim_name
	current_frame = 0
	update_sprite()

func set_walking(walking: bool):
	is_walking = walking
	if not is_casting:
		if walking:
			play_animation("walk")
		else:
			play_animation("idle")

func cast_spell(spell_type: int):
	is_casting = true
	match spell_type:
		1:
			play_animation("cast_fireball")
		2:
			play_animation("cast_lightning")
		3:
			play_animation("cast_frosttrap")
	
	await get_tree().create_timer(frame_duration * FRAME_COUNT).timeout
	is_casting = false
	if is_walking:
		play_animation("walk")
	else:
		play_animation("idle")

