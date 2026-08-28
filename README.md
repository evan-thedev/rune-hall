# Rune Hall

A 3D spell-FPS roguelike demo built in Godot 4.5.

**Author:** Evan Parrott ([@evan-thedev](https://github.com/evan-thedev))  
**License:** MIT

---

## Day 4 Demo

This is the Day 4 slice: three spells + looping floor.

**What's included:**
- Real Godot 4.5 3D project (CharacterBody3D + Camera3D)
- Mouse look and WASD movement
- Walkable dungeon with 4 rooms connected by corridors
- **THREE spell types:**
  - **Projectile Bolt (1)** - Fast magic projectile, dies on walls
  - **Cone Blast (2)** - Area damage in front of player
  - **Trap Rune (3)** - Place on ground, damages enemies that trigger it
- **Spell selection** - Press 1, 2, or 3 to select spell (left-click casts selected spell)
- **Crosshair HUD** - Aim with center-screen crosshair, current spell displayed
- **HP system** - Player health displayed on screen
- **TWO enemy types:**
  - **Grunt** (melee) - Red capsule, chases and hits player in close range
  - **Shooter** (ranged) - Blue capsule, fires projectiles from distance
- **Die-and-retry** - Death reloads the floor, restart from beginning
- **Looping floor** - Continue playing after clearing enemies, floor runs indefinitely

**What's NOT included yet (Day 5+):**
- Pixel art billboards (separate PR)
- Random room generation
- Meta progression
- Web export / GitHub Pages deployment

---

## Controls

- **WASD**: Move
- **Mouse**: Look around
- **1**: Select Projectile Bolt
- **2**: Select Cone Blast
- **3**: Select Trap Rune
- **Left Click**: Cast currently selected spell
- **ESC**: Release/capture mouse

---

## How to Run

### Option 1: Open in Godot 4 Editor

1. **Install Godot 4.5** from [godotengine.org](https://godotengine.org/download)
2. **Clone this repo:**
   ```bash
   git clone https://github.com/evan-thedev/rune-hall.git
   cd rune-hall
   ```
3. **Open the project** in Godot 4:
   - Launch Godot 4.5
   - Click "Import"
   - Navigate to the cloned folder and select `project.godot`
4. **Press F5** or click the Play button to run

### Option 2: Export and Run

Godot 4 can export to Linux, Windows, macOS, and Web (HTML5). Exports will be added after Day 1 review.

---

## Tech Stack

- **Engine:** Godot 4.5 (stable)
- **Language:** GDScript
- **Renderer:** OpenGL (Compatibility mode for web export)
- **3D Geometry:** CSGBox3D (procedural rooms and corridors)

---

## Roadmap

- [x] Day 1: FPS movement + walkable 3D space
- [x] Day 2: Projectile spell + HP + crosshair + basic enemy
- [x] Day 3: Two enemy types (grunt + shooter) + die-and-retry
- [x] Day 4: Three spells (projectile, cone, trap) + looping floor
- [ ] Day 4B: Pixel art integration (separate PR)
- [ ] Day 5: Web export + GitHub Pages deployment

---

## Why This Demo?

This project demonstrates:
- Godot 4 3D game development
- Character controller implementation (physics, collision, camera)
- Multiple spell systems (projectile, area, placement)
- Spell switching and cooldown management
- Enemy AI with pathfinding and combat
- HP and damage systems
- HUD and UI implementation
- Procedural level generation
- Clean, modular GDScript architecture

Built as a hiring portfolio piece. Honest scope, no fake claims.
