# Everdune Stack Lock

**Status: LOCKED — September 2026**

**Production pin: Godot 4.7.2-stable.** The official Godot archive lists 4.7.2 as the current stable 4.7 maintenance release; 4.8 is still development/pre-release. citeturn0search0turn0search3

The first commercial Everdune game is built as a native Godot game.

## Runtime
- **Engine:** Godot 4.x, pinned to a stable production release before distribution.
- **Language:** GDScript for gameplay and orchestration.
- **Native escape hatch:** GDExtension only when profiling proves it necessary.
- **Rendering:** Godot 2D renderer with pixel-aware presentation, dynamic lighting, particles and post-processing.
- **World:** Godot scenes/resources plus TileMapLayer/TileSet as the authored tile world matures.
- **State:** data-driven simulation separated from presentation.
- **Save:** versioned local save schema from the first vertical slice.
- **Steam:** platform adapter boundary; Steamworks integration is added without contaminating gameplay code.
- **Source control:** GitHub.
- **Validation:** automated checks + headless Godot validation + AI production Gauntlet.

## Companion stack
- **Website:** Astro + TypeScript.
- **Interactive web graphics:** Three.js/WebGPU where genuinely useful.
- **Web is not the game runtime.**

## Why this is locked
Everdune is a 2D pixel-first Steam RPG with a growing systemic world, authored scenes, simulation, future co-op, and a long production life. Godot gives the project a dedicated 2D/game runtime instead of requiring us to build an engine layer on top of a web renderer.

Three.js remains valuable for the By JTT / Everdune web experience and specialist tools. It is not the primary game engine.

## Architecture rule
**Simulation → State → Presentation**

Gameplay systems must not depend on UI implementation details. UI observes state; presentation reacts to state.

## Vertical slice acceptance target
The first slice must prove:

Character → Hearthfall → Move → Gather → Craft → Fish → Talk → Discover Echo → Rest → Save → Load

No HTML prototype is considered a substitute for this runtime.