extends CanvasLayer

@onready var health_label = $Control/MarginContainer/VBoxContainer/HealthLabel
@onready var crosshair = $Control/Crosshair
@onready var hotbar = $Control/Hotbar

const SPELL_ICONS = {
	1: "res://sprites/icon-fireball.png",
	2: "res://sprites/icon-lightning.png",
	3: "res://sprites/icon-frosttrap.png"
}

var current_spell = 1
var hotbar_visible_time = 0.0
var hotbar_display_duration = 2.0

func _ready():
	add_to_group("hud")
	update_spell(1)
	setup_hotbar()

func _process(delta):
	if hotbar_visible_time > 0:
		hotbar_visible_time -= delta
		if hotbar_visible_time <= 0:
			hide_hotbar()

func setup_hotbar():
	for i in range(1, 4):
		var slot = hotbar.get_node("Slot" + str(i))
		if slot:
			var icon = slot.get_node("Icon")
			if icon and ResourceLoader.exists(SPELL_ICONS[i]):
				icon.texture = load(SPELL_ICONS[i])

func update_health(current: float, maximum: float):
	if health_label:
		health_label.text = "HP: %d / %d" % [int(current), int(maximum)]

func update_spell(spell_num: int):
	current_spell = spell_num
	show_hotbar()
	update_hotbar_selection()

func show_hotbar():
	if hotbar:
		hotbar.visible = true
		hotbar_visible_time = hotbar_display_duration

func hide_hotbar():
	if hotbar:
		hotbar.visible = false

func update_hotbar_selection():
	for i in range(1, 4):
		var slot = hotbar.get_node("Slot" + str(i))
		if slot:
			var panel = slot.get_node("Panel")
			if panel:
				if i == current_spell:
					panel.modulate = Color(1.0, 1.0, 0.5, 1.0)
				else:
					panel.modulate = Color(0.5, 0.5, 0.5, 0.8)
