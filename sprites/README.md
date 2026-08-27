# Sprite Assets

This directory contains sprite sheets for goblin enemies with black (#000000) transparency.

## Expected Format

Each sprite sheet should be:
- **Format**: PNG with black (#000000) background for transparency
- **Style**: Pixel art with nearest-neighbor filtering (no smoothing)
- **Frames**: Variable per animation type (see below)

## Goblin Sprite Sheets

### Dagger Goblin (Melee Enemy)

**Single Frame:**
- `dagger-goblin-idle.png` - 1-frame idle pose

**Walk Animations (6 frames each):**
- `dagger-goblin-walk-front.png` - Walking toward camera
- `dagger-goblin-walk-back.png` - Walking away from camera
- `dagger-goblin-walk-left.png` - Walking left
- `dagger-goblin-walk-right.png` - Walking right

**Combat Animations:**
- `dagger-goblin-attack.png` - 5-frame dagger slash
- `dagger-goblin-flinch.png` - 4-frame hit reaction
- `dagger-goblin-death.png` - 6-frame collapse (last frame = corpse with dagger on ground)

### Loot Goblin (Ranged Enemy)

**Single Frame:**
- `loot-goblin-idle.png` - 1-frame idle pose with treasure sack

**Walk Animations (6 frames each):**
- `loot-goblin-walk-front.png` - Walking toward camera
- `loot-goblin-walk-back.png` - Walking away from camera
- `loot-goblin-walk-left.png` - Walking left
- `loot-goblin-walk-right.png` - Walking right

**Combat Animations:**
- `loot-goblin-attack.png` - 5-frame gold toss (ranged attack)
- `loot-goblin-flinch.png` - 4-frame hit reaction
- `loot-goblin-death.png` - 6-frame collapse with coin spill (last frame = corpse with loot on floor)

## Implementation

The sprites use billboard Sprite3D nodes that always face the camera. The system automatically:
- Chooses correct walk direction sprite based on movement (front/back/left/right)
- Plays attack animations when enemies attack
- Shows flinch animation when taking damage
- Plays death animation before enemy removal
- Cycles through frames at 8 FPS for multi-frame animations

## Animation States

- **IDLE**: 1-frame idle pose
- **WALK**: 6-frame directional animation (front/back/left/right chosen by movement)
- **ATTACK**: 5-frame animation (dagger slash or gold toss)
- **FLINCH**: 4-frame hit reaction
- **DEATH**: 6-frame collapse animation (last frame shows corpse with dropped items)

## Replacing Placeholders

To replace the placeholder sprites:
1. Drop the new PNG files into this directory
2. Godot will automatically re-import them with the configured settings
3. The game will immediately use the new art (no code changes needed)

The import settings are pre-configured for:
- Nearest-neighbor filtering (no blur)
- No compression (crisp pixels)
- Black (#000000) background treated as transparent
