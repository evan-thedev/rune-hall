extends Node3D

@onready var sprite = $Sprite3D
@onready var animation_player = $AnimationPlayer

var current_animation = "idle"
var is_walking = false
var is_casting = false

var idle_frames = []
var walk_frames = []
var cast_fireball_frames = []
var cast_lightning_frames = []
var cast_frosttrap_frames = []

var current_frame = 0
var frame_time = 0.0
var frame_duration = 0.1

func _ready():
	load_sprite_frames()
	play_animation("idle")

func load_sprite_frames():
	idle_frames = load_frames_from_sheet("res://sprites/hand-idle.png", 1, 1)
	walk_frames = load_frames_from_sheet("res://sprites/hand-walk.png", 6, 1)
	cast_fireball_frames = load_frames_from_sheet("res://sprites/hand-cast-fireball.png", 6, 1)
	cast_lightning_frames = load_frames_from_sheet("res://sprites/hand-cast-lightning.png", 6, 1)
	cast_frosttrap_frames = load_frames_from_sheet("res://sprites/hand-cast-frosttrap.png", 6, 1)

func load_frames_from_sheet(path: String, frame_count: int, rows: int) -> Array:
	var frames = []
	if ResourceLoader.exists(path):
		var texture = load(path)
		if texture:
			for i in range(frame_count):
				frames.append(texture)
	return frames

func _process(delta):
	frame_time += delta
	if frame_time >= frame_duration:
		frame_time = 0.0
		advance_frame()

func advance_frame():
	var frames = get_current_frames()
	if frames.size() > 0:
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
	
	await get_tree().create_timer(frame_duration * 6).timeout
	is_casting = false
	if is_walking:
		play_animation("walk")
	else:
		play_animation("idle")
