extends CanvasLayer

@onready var health_label = $Control/MarginContainer/VBoxContainer/HealthLabel
@onready var crosshair = $Control/Crosshair

func _ready():
	add_to_group("hud")

func update_health(current: float, maximum: float):
	if health_label:
		health_label.text = "HP: %d / %d" % [int(current), int(maximum)]
