extends CanvasLayer

@onready var health_label = $Control/MarginContainer/VBoxContainer/HealthLabel
@onready var spell_label = $Control/MarginContainer/VBoxContainer/SpellLabel
@onready var crosshair = $Control/Crosshair

const SPELL_NAMES = {
	1: "Spell: Projectile (1)",
	2: "Spell: Cone Blast (2)",
	3: "Spell: Trap Rune (3)"
}

func _ready():
	add_to_group("hud")
	update_spell(1)

func update_health(current: float, maximum: float):
	if health_label:
		health_label.text = "HP: %d / %d" % [int(current), int(maximum)]

func update_spell(spell_num: int):
	if spell_label:
		spell_label.text = SPELL_NAMES.get(spell_num, "Unknown Spell")
