# Architecture Consolidation

## Objective

Convert the vertical-slice foundation from prototype-shaped orchestration into a maintainable AI-native production architecture without adding gameplay breadth.

## Completed

- Removed the obsolete pre-TileMap world renderer.
- Established canonical system ownership in docs/SYSTEM_MAP.md.
- Split major gameplay responsibilities out of main.gd.
- Introduced Godot Resource data for Echoes, NPCs and locations.
- Added deterministic Echo/content regression.
- Added save migration and real save round-trip checks.
- Made the runtime asset manifest exhaustive.
- Made CI fail on obsolete paths and manifest drift.
- Kept Hearthfall art explicitly in placeholder status until the visual gate passes.

## Architectural invariant

Content → Systems → State → Presentation.

main.gd is orchestration, not a content database.

## Scope

No new regions, enemy families, procedural breadth, multiplayer transport or Gauntlet systems are part of this consolidation. After the engineering gate is green, the next product phase is the serious Hearthfall visual/feel pass.
