# Rune Hall

A 3D spell-FPS roguelike demo built in Godot 4.3.

**Author:** Evan Parrott ([@evan-thedev](https://github.com/evan-thedev))  
**License:** MIT

---

## Day 1 Demo

This is the Day 1 slice: basic FPS movement in a walkable 3D dungeon.

**What's included:**
- Real Godot 4.3 3D project (CharacterBody3D + Camera3D)
- Mouse look and WASD movement
- Collision system that stops the player at walls
- A simple dungeon layout with 4 rooms connected by corridors

**What's NOT included yet (Day 2):**
- Spell casting system (3 spells planned)
- Enemy AI (2 types planned)
- Roguelike mechanics
- Web export / GitHub Pages deployment

---

## Controls

- **WASD**: Move
- **Mouse**: Look around
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
- [ ] Day 2: 3 spell types (projectile, cone, trap)
- [ ] Day 2: 2 enemy types (melee, ranged)
- [ ] Day 2: One-floor roguelike run (die-and-retry)
- [ ] Day 2: Web export + GitHub Pages deployment

---

## Why This Demo?

This project demonstrates:
- Godot 4 3D game development
- Character controller implementation (physics, collision, camera)
- Procedural level generation
- Clean, modular GDScript architecture

Built as a hiring portfolio piece. Honest scope, no fake claims.
