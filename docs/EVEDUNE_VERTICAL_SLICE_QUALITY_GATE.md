# Everdune Vertical Slice Quality Gate

Date: 2026-09-27
Status: ACTIVE — NOT PASSED

## Purpose

This is the next major product gate. It is deliberately smaller than a full game release and deliberately stricter than an engineering prototype.

The slice must make a player believe they are playing the real Everdune experience.

## Required player journey

Real loading
→ beautiful title
→ excellent character creation
→ first Hearthfall frame
→ movement feels excellent
→ world looks authored and alive
→ Mara feels like a real character
→ gathering/fishing feel satisfying
→ first Echo feels magical and unique
→ crafting feels meaningful
→ Sleeping Gate feels dramatically different
→ combat feels good
→ returning home feels emotionally satisfying

## Three gates must pass together

### Engineering truth

- The runtime is the real Godot game.
- Browser and native builds use the same gameplay source.
- Interactions, progression and save/load work reliably.
- No fake loading, fake progress or fake readiness.
- Systems remain data-driven and replaceable.

### Production truth

- Temporary implementations are explicitly registered.
- P0 placeholders are visible and tracked.
- World geography is owned by world data, not scattered coordinate hacks.
- Content can be extended without rewriting the foundation.
- Automated verification exists wherever practical.

### Player truth

- The first frame establishes Everdune's identity.
- Controls feel immediate and readable.
- Visuals match the locked Cinematic Pixel Fantasy language.
- Every interaction has satisfying feedback.
- NPCs feel authored rather than functional.
- The first Echo communicates why Everdune is different.
- The Sleeping Gate changes tone and intensity.
- Returning home creates an emotional sense of continuity.

## Brutal placeholder rule

If any asset, screen, mechanic, NPC, animation, sound, environment or technical treatment makes the review say:

“it's only a placeholder for now”

the gate fails that area.

The item must be explicitly classified in docs/PLACEHOLDER_REGISTRY.md.

It cannot become invisible technical debt.

## Current gate matrix

| Gate area | Current state | Blocking issue |
|---|---|---|
| Real loading | IN PROGRESS | Needs final presentation QA |
| Beautiful title | IN PROGRESS | Current runtime art remains below canonical visual bar |
| Character creation | IN PROGRESS | Hero layer breadth and art fidelity incomplete |
| First Hearthfall frame | FAIL | Current scene is an authored scaffold, not final canonical art |
| Movement feel | IN PROGRESS | Needs player-feel QA and authored animation |
| Authored/alive world | FAIL | Production TileMap topology, collision and environmental density incomplete |
| Mara as character | FAIL | Dialogue/simulation depth and visual identity incomplete |
| Gathering/fishing | IN PROGRESS | Feedback/audio still uses placeholder-quality implementations |
| First Echo | FAIL | Needs signature presentation and reusable Echo architecture |
| Meaningful crafting | IN PROGRESS | Core loop exists; item identity and feedback need production pass |
| Sleeping Gate contrast | FAIL | Dungeon presentation and encounter design are still foundational |
| Combat feel | FAIL | Telegraphs, impact, animation and encounter design incomplete |
| Return-home emotion | FAIL | World-state continuity and authored emotional presentation incomplete |

## Pass criteria

The gate passes only when:

1. No unresolved P0 placeholder remains in the player journey without an explicit approved exception.
2. Every journey stage has both functional and experiential evidence.
3. The visual runtime is comparable to the approved visual master.
4. The complete regression journey can be reproduced from a clean save.
5. Save/load does not break the journey.
6. Browser and native builds share the same gameplay implementation.
7. The review cannot honestly describe any major journey element as “only a placeholder.”
8. Second-Eyes Player and Production reviews both pass.

## Scope lock

Until this gate passes:

- do not add new regions merely for breadth,
- do not expand procedural generation,
- do not add large content libraries to disguise quality gaps,
- do not treat working systems as finished product,
- do not silently promote placeholders to production status.

Improve the existing journey first.

## After the gate

Only after this gate passes should the project scale into:

- additional regions,
- deeper NPC simulation,
- broader equipment,
- systemic Echoes,
- controlled procedural content,
- Gauntlet,
- Steam integration,
- co-op transport,
- long-term replayability systems.

The vertical slice is the quality laboratory for everything that follows.