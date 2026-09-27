# Everdune — Placeholder Registry

Date: 2026-09-27

## Purpose

This registry prevents temporary implementations from becoming invisible technical debt.

A placeholder is any asset, screen, mechanic, NPC, animation, sound, environment, UI treatment, data model, or technical implementation that is knowingly below the approved Everdune production bar.

A placeholder is not complete merely because it works.

Every placeholder must remain explicitly classified until it passes the same Second-Eyes gate as the finished experience.

## Required states

- PLACEHOLDER — intentionally temporary and visibly tracked.
- IN_PROGRESS — production replacement is actively being built.
- QA — replacement exists and is undergoing functional + experiential review.
- PASSED — replacement has passed the relevant Second-Eyes gate.
- BLOCKED — replacement cannot proceed because a named dependency is missing.

## Gate rule

No release candidate may contain an unclassified temporary implementation.

If a reviewer says:
- “it's only a placeholder”
- “we'll polish that later”
- “the player probably won't notice”
- “the final art/audio/UI will come later”

then the item must be added here immediately.

## Current registry

| Area | Item | Current state | Replacement / acceptance target | Priority |
|---|---|---|---|---|
| Art | Hearthfall scene SVG | IN_PROGRESS | Canonical Cinematic Pixel Fantasy environment matching the approved visual master; authored depth, lighting, landmarks and texture | P0 |
| Art | Hero body/hair/coat sheets | PLACEHOLDER | Canonical high-detail hero with full layer set and authored directional animation | P0 |
| Art | Props / terrain atlas | PLACEHOLDER | Production pixel-art atlas with validated density, palette, pivots and landmark-specific variants | P0 |
| UI | Title screen presentation | IN_PROGRESS | Beautiful, identity-defining title experience with clear hierarchy, atmosphere and tactile interaction | P0 |
| UI | Character creator | IN_PROGRESS | Fast, expressive creator with production hero preview and readable choices | P0 |
| World | Visible Hearthfall map | PLACEHOLDER | Production-authored TileMapLayer map with proper collision, transitions and authored topology | P0 |
| World | Hardcoded river collision | PLACEHOLDER | TileSet/scene collision geometry owned by the world data | P0 |
| NPC | Mara / Rowan | PLACEHOLDER | Authored portraits/silhouettes, routines, schedules, contextual dialogue and memory reactions | P1 |
| Echo | Hardcoded Echo interactions | PLACEHOLDER | Reusable Echo data model with evidence presentation and world consequences | P1 |
| Audio | Runtime generated tones | PLACEHOLDER | Authored music, ambience, biome audio, interaction and combat soundscape | P0 |
| Combat | Basic attack presentation | PLACEHOLDER | Authored attack animation, telegraph, impact language, enemy variants and encounter design | P1 |
| Save | Current small save payload | IN_PROGRESS | Versioned, atomic, corruption-safe save with migration tests and persisted world state | P1 |
| VFX | Polygon2D feedback effects | PLACEHOLDER | Authored pixel-aware VFX language integrated with the visual bible | P1 |
| QA | Manual regression journey | IN_PROGRESS | Automated deterministic regression plus Second-Eyes player/production review | P1 |

## Retirement rule

When an item passes, update this registry in the same change that removes or retires the implementation. Do not delete the historical classification without recording what replaced it.

## Second-Eyes evidence

A PASSED item must be backed by:
1. a reproducible runtime path,
2. a functional verification path where practical,
3. visual/product review against the approved Everdune reference,
4. no known placeholder caveat remaining in that area.

## Relationship to scaling

World/content scaling is blocked by unresolved P0 placeholders in the vertical slice.

The vertical slice becomes the quality laboratory. Scale only after the laboratory passes.