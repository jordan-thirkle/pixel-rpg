# Everdune AI Agent Contract

Read PROJECT.md and TODO.md before any implementation.

## Required preflight
1. Identify the active TODO task.
2. Identify the canonical owner.
3. Read the existing implementation.
4. State acceptance criteria.
5. Identify the validation path.

## Canonical pattern
Content data → gameplay systems → GameState → presentation.

Examples:
- Echo: game/data/echoes + echo_system.gd
- NPC: game/data/npcs + npc_system.gd
- Location: game/data/locations + location_system.gd
- Visual: canonical asset + asset manifest + visual QA

## Forbidden
- hardcoded content databases in main.gd;
- second world renderer;
- duplicate gameplay authority;
- generic replacement for canonical assets;
- invisible placeholders;
- architecture rewrites for isolated features;
- speculative features outside TODO priority.

## Completion
A task is complete only when code/data/docs agree, validation passes, TODO.md is updated, and known risks are recorded.

## Handoff
Record task, owner, files, validation, evidence, risk and next task.
