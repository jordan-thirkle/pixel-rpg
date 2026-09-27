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
The repository contains the real Godot runtime in `game/`. It is an executable vertical-slice foundation, not a final-art release.

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

This is intentionally a production foundation rather than a final-art release. See `docs/SECOND_EYES_AUDIT.md` for the current ruthless gate assessment. Final visual fidelity, authored content depth, audio, collision, simulation breadth and commercial polish remain active work.

## Source of truth
- `docs/GENESIS.md` — game identity and lore foundation
- `docs/STACK_LOCK.md` — locked technology decisions
- `docs/PIXEL_ART_BIBLE.md` — visual rules
- `docs/TECHNICAL_FOUNDATION.md` — architecture
- `docs/PRODUCTION_RULES.md` — AI production/governance rules
- `game/` — actual runtime

**No HTML prototype is a substitute for the Godot runtime.**