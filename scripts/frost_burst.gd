extends Node3D

var frames = []
var sprite = null
var current_frame = 0
var frame_timer = 0.0
const FRAME_DURATION = 0.08

func _process(delta):
	frame_timer += delta
	if frame_timer >= FRAME_DURATION:
		frame_timer = 0.0
		current_frame += 1
		if current_frame < frames.size():
			if sprite:
				sprite.texture = frames[current_frame]
				# Update shader parameter for chroma keying
				if sprite.material_override:
					sprite.material_override.set_shader_parameter("texture_albedo", frames[current_frame])
		else:
			queue_free()
