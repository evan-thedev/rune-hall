# Sprite Assets

This directory contains sprite sheets for enemy characters. The current files are 1x1 pixel placeholders.

## Expected Format

Each sprite sheet should be:
- **Dimensions**: 6 horizontal frames (approximately 170x284 pixels total, ~28x47 per frame)
- **Format**: PNG with magenta (#FF00FF) background for transparency
- **Style**: Pixel art with nearest-neighbor filtering (no smoothing)

## Sprite Sheets

### Grunt (Melee Enemy)
- `grunt_idle_front.png` - 6-frame breathing/idle animation
- `grunt_walk_front.png` - 6-frame walking animation  
- `grunt_attack_front.png` - 6-frame melee attack animation

### Shooter (Ranged Enemy)
- `shooter_idle_front.png` - 6-frame idle animation (staff visible in every frame)
- `shooter_walk_front.png` - 6-frame walking animation
- `shooter_attack_front.png` - 6-frame ranged attack animation

## Implementation

The sprites are used as billboard Sprite3D nodes that always face the camera. The `sprite_animator.gd` script handles frame cycling at 8 FPS. Enemy scripts automatically switch between idle/walk/attack animations based on their behavior state.

## Replacing Placeholders

To replace the placeholder sprites:
1. Drop the new PNG files into this directory
2. Godot will automatically re-import them with the configured settings
3. The game will immediately use the new art (no code changes needed)

The import settings are pre-configured for:
- Nearest-neighbor filtering (no blur)
- No compression (crisp pixels)
- Transparent magenta background
