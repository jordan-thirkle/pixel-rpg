# Everdune

**The World Remembers.**

Everdune is a native Godot 4.x pixel-fantasy RPG being built as an AI-native solo-development project.

## Locked production stack
- Godot 4.7.2-stable
- GDScript
- Godot 2D runtime
- Data-driven simulation
- GitHub + GitHub Actions
- Steam-first premium release
- Astro/TypeScript + Three.js reserved for the companion web experience

See [docs/STACK_LOCK.md](docs/STACK_LOCK.md).

## Real vertical slice
The repository now contains the first playable Godot runtime in `game/`.

The slice proves:

**Character → Hearthfall → Move → Gather → Craft → Fish → Talk → Discover Echo → Rest → Save → Load**

Controls:
- WASD / arrows — move
- E — interact
- I — inventory
- C — craft
- K — save
- L — load
- Space — prototype combat action
- Esc — close panels

This is intentionally the gameplay foundation rather than the final art pass. The next production layer is the canonical pixel asset pipeline, authored TileMapLayer world, animation, audio, combat depth, quest systems, and the full Echo simulation.

## Source of truth
- `docs/GENESIS.md` — game identity and lore foundation
- `docs/STACK_LOCK.md` — locked technology decisions
- `docs/PIXEL_ART_BIBLE.md` — visual rules
- `docs/TECHNICAL_FOUNDATION.md` — architecture
- `docs/PRODUCTION_RULES.md` — AI production/governance rules
- `game/` — actual runtime

**No HTML prototype is a substitute for the Godot runtime.**