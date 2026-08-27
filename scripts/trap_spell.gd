extends Area3D

const DAMAGE = 30.0
const LIFETIME = 10.0
const ARM_TIME = 0.3
const GLYPH_SPIN_SPEED = 2.0
const GLYPH_FRAME_COUNT = 6
const GLYPH_FRAME_DURATION = 0.1
const FROST_BURST_SCRIPT = preload("res://scripts/frost_burst.gd")

var time_alive = 0.0
var is_armed = false
var has_triggered = false
var glyph_frame_time = 0.0
var current_glyph_frame = 0
var glyph_frames = []

@onready var glyph_sprite = $GlyphSprite3D

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	load_glyph_frames()

func load_glyph_frames():
	if ResourceLoader.exists("res://sprites/frosttrap-glyph.png"):
		var sheet = load("res://sprites/frosttrap-glyph.png")
		if sheet:
			for i in range(GLYPH_FRAME_COUNT):
				var atlas = AtlasTexture.new()
				atlas.atlas = sheet
				var frame_width = sheet.get_width() / GLYPH_FRAME_COUNT
				atlas.region = Rect2(i * frame_width, 0, frame_width, sheet.get_height())
				glyph_frames.append(atlas)
			
			if glyph_sprite and glyph_frames.size() > 0:
				glyph_sprite.texture = glyph_frames[0]

func _physics_process(delta):
	time_alive += delta
	
	if time_alive >= ARM_TIME and not is_armed:
		is_armed = true
	
	if glyph_sprite and is_armed:
		glyph_sprite.rotate_y(GLYPH_SPIN_SPEED * delta)
		
		glyph_frame_time += delta
		if glyph_frame_time >= GLYPH_FRAME_DURATION and glyph_frames.size() > 0:
			glyph_frame_time = 0.0
			current_glyph_frame = (current_glyph_frame + 1) % glyph_frames.size()
			glyph_sprite.texture = glyph_frames[current_glyph_frame]
	
	if time_alive > LIFETIME:
		queue_free()

func _on_body_entered(body):
	if not is_armed or has_triggered:
		return
	
	if body.is_in_group("player") or body.is_in_group("enemy"):
		trigger_trap(body)

func _on_area_entered(area):
	if not is_armed or has_triggered:
		return
	
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy:
			trigger_trap(enemy)

func trigger_trap(actor):
	has_triggered = true
	
	if actor.has_method("take_damage"):
		actor.take_damage(DAMAGE)
	
	spawn_ice_burst()
	
	if glyph_sprite:
		glyph_sprite.visible = false
	if has_node("OmniLight3D"):
		$OmniLight3D.visible = false
	
	queue_free()

func spawn_ice_burst():
	if not ResourceLoader.exists("res://sprites/frosttrap-burst.png"):
		spawn_ice_burst_fallback()
		return
	
	var burst_anim = Node3D.new()
	get_tree().root.add_child(burst_anim)
	burst_anim.global_position = global_position
	
	var sprite = Sprite3D.new()
	sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sprite.pixel_size = 0.02
	sprite.position = Vector3(0, 0.5, 0)
	burst_anim.add_child(sprite)
	
	var sheet = load("res://sprites/frosttrap-burst.png")
	const BURST_FRAME_COUNT = 5
	const FRAME_DURATION = 0.08
	
	var frames = []
	if sheet:
		var frame_width = sheet.get_width() / BURST_FRAME_COUNT
		for i in range(BURST_FRAME_COUNT):
			var atlas = AtlasTexture.new()
			atlas.atlas = sheet
			atlas.region = Rect2(i * frame_width, 0, frame_width, sheet.get_height())
			frames.append(atlas)
	
	if frames.size() == 0:
		burst_anim.queue_free()
		spawn_ice_burst_fallback()
		return
	
	sprite.texture = frames[0]
	
	burst_anim.set_script(FROST_BURST_SCRIPT)
	burst_anim.set("frames", frames)
	burst_anim.set("sprite", sprite)

func spawn_ice_burst_fallback():
	var burst = Node3D.new()
	get_tree().root.add_child(burst)
	burst.global_position = global_position
	
	for i in range(8):
		var shard = CSGBox3D.new()
		shard.size = Vector3(0.1, 0.8, 0.1)
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.6, 0.8, 1.0, 1.0)
		shard.material = mat
		burst.add_child(shard)
		
		var angle = i * PI / 4.0
		var start_pos = Vector3(cos(angle) * 0.3, 0.4, sin(angle) * 0.3)
		var end_pos = Vector3(cos(angle) * 0.5, 1.5, sin(angle) * 0.5)
		shard.position = start_pos
		shard.rotation.y = angle
		
		var tween = burst.create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(shard, "position", end_pos, 0.4)
		tween.parallel().tween_property(shard.material, "albedo_color:a", 0.0, 0.4)
	
	var cleanup_timer = burst.get_tree().create_timer(0.5)
	cleanup_timer.timeout.connect(func(): burst.queue_free())
