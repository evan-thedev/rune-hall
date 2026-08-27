extends Area3D

const DAMAGE = 30.0
const LIFETIME = 10.0
const ARM_TIME = 0.3
const GLYPH_SPIN_SPEED = 2.0

var time_alive = 0.0
var is_armed = false
var has_triggered = false

@onready var glyph_sprite = $GlyphSprite3D

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta):
	time_alive += delta
	
	if time_alive >= ARM_TIME and not is_armed:
		is_armed = true
	
	if glyph_sprite and is_armed:
		glyph_sprite.rotate_y(GLYPH_SPIN_SPEED * delta)
	
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
	
	var burst_sprite = Sprite3D.new()
	burst_sprite.texture = load("res://sprites/frosttrap-burst.png")
	burst_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	burst_sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	burst_sprite.pixel_size = 0.01
	
	get_tree().root.add_child(burst_sprite)
	burst_sprite.global_position = global_position + Vector3(0, 0.5, 0)
	
	var tween = burst_sprite.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(burst_sprite, "scale", Vector3(2, 2, 2), 0.4)
	tween.parallel().tween_property(burst_sprite, "modulate:a", 0.0, 0.4)
	
	var cleanup_timer = burst_sprite.get_tree().create_timer(0.5)
	cleanup_timer.timeout.connect(func(): burst_sprite.queue_free())

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
