# Rune Hall

A 3D spell-FPS roguelike demo built in Godot 4.3.

**Author:** Evan Parrott ([@evan-thedev](https://github.com/evan-thedev))  
**License:** MIT

---

## Day 2 Demo

This is the Day 2 slice: spell combat, HP system, and basic enemies.

**What's included:**
- Real Godot 4.3 3D project (CharacterBody3D + Camera3D)
- Mouse look and WASD movement
- Walkable dungeon with 4 rooms connected by corridors
- **Projectile spell** - Cast magic projectiles at enemies
- **Crosshair HUD** - Aim with center-screen crosshair
- **HP system** - Player health displayed on screen
- **Basic enemies** - Hostile enemies that chase and attack

**What's NOT included yet (Day 3+):**
- Multiple spell types (cone, trap)
- Multiple enemy types (ranged)
- Full roguelike mechanics (die-and-retry, random rooms)
- Web export / GitHub Pages deployment

---

## Controls

- **WASD**: Move
- **Mouse**: Look around
- **Left Click**: Cast projectile spell
- **ESC**: Release/capture mouse

---

## How to Run

### Option 1: Open in Godot 4 Editor

1. **Install Godot 4.3** from [godotengine.org](https://godotengine.org/download)
2. **Clone this repo:**
   ```bash
   git clone https://github.com/evan-thedev/rune-hall.git
   cd rune-hall
   ```
3. **Open the project** in Godot 4:
   - Launch Godot 4.3
   - Click "Import"
   - Navigate to the cloned folder and select `project.godot`
4. **Press F5** or click the Play button to run

### Option 2: Export and Run

Godot 4 can export to Linux, Windows, macOS, and Web (HTML5). Exports will be added after Day 1 review.

---

## Tech Stack

- **Engine:** Godot 4.3 (stable)
- **Language:** GDScript
- **Renderer:** OpenGL (Compatibility mode for web export)
- **3D Geometry:** CSGBox3D (procedural rooms and corridors)

---

## Roadmap

- [x] Day 1: FPS movement + walkable 3D space
- [x] Day 2: Projectile spell + HP + crosshair + basic enemy
- [ ] Day 3+: Multiple spell types (cone, trap)
- [ ] Day 3+: Multiple enemy types (ranged)
- [ ] Day 3+: Full roguelike mechanics (die-and-retry)
- [ ] Day 5: Web export + GitHub Pages deployment

---

## Why This Demo?

This project demonstrates:
- Godot 4 3D game development
- Character controller implementation (physics, collision, camera)
- Spell casting and projectile systems
- Enemy AI with pathfinding and combat
- HP and damage systems
- HUD and UI implementation
- Procedural level generation
- Clean, modular GDScript architecture

Built as a hiring portfolio piece. Honest scope, no fake claims.
