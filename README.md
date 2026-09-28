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

## Architecture consolidation

The current foundation follows Content → Systems → State → Presentation. Canonical ownership is defined in [docs/SYSTEM_MAP.md](docs/SYSTEM_MAP.md), AI implementation boundaries in [docs/AI_AGENT_CONTRACT.md](docs/AI_AGENT_CONTRACT.md), and the consolidation record in [docs/ARCHITECTURE_CONSOLIDATION.md](docs/ARCHITECTURE_CONSOLIDATION.md).

Gameplay content is moving into Godot Resources so Echoes, NPCs and locations can scale without expanding the orchestration script. CI validates repository drift, runtime asset manifests, Godot parsing and deterministic vertical-slice/save regressions.


## Free-play depth pass

The architecture is frozen. The current development focus is now systemic depth inside Larkmere rather than another framework.

The runtime now has a broader skill family, skill-specific gathering, repeatable cooking/gardening/building/wayfinding/decorating activities, persistent activity counts, world memories, NPC memories, home progression, garden state and systemic Echo metadata.

See:
- [docs/FREE_PLAY_FOUNDATION.md](docs/FREE_PLAY_FOUNDATION.md)
- [docs/LARKMERE_CONTENT_PLAN.md](docs/LARKMERE_CONTENT_PLAN.md)
- [docs/ROADMAP_2026_PLUS.md](docs/ROADMAP_2026_PLUS.md)

The product pressure test is simple:

**Can a player ignore the story, spend 45 minutes doing whatever sounds good, and feel that their evening mattered?**
