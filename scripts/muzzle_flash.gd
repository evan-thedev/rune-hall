extends OmniLight3D

const FLASH_DURATION = 0.08

func _ready():
	await get_tree().create_timer(FLASH_DURATION).timeout
	queue_free()
