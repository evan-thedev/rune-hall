# Sprite Assets

This directory contains sprite sheets for enemy characters. The current files are 1x1 pixel placeholders.

## Expected Format

Each sprite sheet should be:
- **Dimensions**: 6 horizontal frames (approximately 170x284 pixels total, ~28x47 per frame)
- **Format**: PNG with magenta (#FF00FF) background for transparency
- **Style**: Pixel art with nearest-neighbor filtering (no smoothing)

## Sprite Sheets

### Grunt (Melee Enemy)

**Front View:**
- `grunt_idle_front.png` - 6-frame breathing/idle animation
- `grunt_walk_front.png` - 6-frame walking animation  
- `grunt_attack_front.png` - 6-frame melee attack animation

**Side View:**
- `grunt_idle_side.png` - 6-frame side idle animation
- `grunt_walk_side.png` - 6-frame side walking animation
- `grunt_attack_side.png` - 6-frame side melee attack animation

### Shooter (Ranged Enemy)

**Front View:**
- `shooter_idle_front.png` - 6-frame idle animation (staff visible in every frame)
- `shooter_walk_front.png` - 6-frame walking animation
- `shooter_attack_front.png` - 6-frame ranged attack animation

**Side View:**
- `shooter_idle_side.png` - 6-frame side idle (staff in every frame)
- `shooter_walk_side.png` - 6-frame side walking
- `shooter_attack_side.png` - 6-frame side attack (bolt from orb, bone feet visible)

## Implementation

The sprites use billboard Sprite3D nodes that always face the camera. The system automatically:
- Switches between front and side views based on camera angle
- Mirrors the side sprite when viewed from the left
- Cycles through 6 frames at 8 FPS
- Transitions between idle/walk/attack states based on enemy behavior

## Camera-Relative Display

The sprite system calculates the viewing angle and shows:
- **Front sprites**: When camera is looking at front or back of enemy
- **Side sprites**: When camera is looking at left or right of enemy
- **Mirroring**: Left-facing views flip the side sprite horizontally

## Replacing Placeholders

To replace the placeholder sprites:
1. Drop the new PNG files into this directory
2. Godot will automatically re-import them with the configured settings
3. The game will immediately use the new art (no code changes needed)

The import settings are pre-configured for:
- Nearest-neighbor filtering (no blur)
- No compression (crisp pixels)
- Transparent magenta background
