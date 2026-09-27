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
| Art | Hero body/hair/coat + production layer set | IN_PROGRESS | Full high-detail hero remains the remaining visual gate; new face/shirt/trouser/boot/accessory/back layers are integrated and animated | P0 |
| Art | Props / terrain atlas | PLACEHOLDER | Production pixel-art atlas with validated density, palette, pivots and landmark-specific variants | P0 |
| UI | Title screen presentation | IN_PROGRESS | Beautiful, identity-defining title experience with clear hierarchy, atmosphere and tactile interaction | P0 |
| UI | Character creator | IN_PROGRESS | Fast, expressive creator with production hero preview and readable choices | P0 |
| World | Visible Hearthfall map | IN_PROGRESS | Multi-layer authored TileMap topology now drives ground, river and paths; landmark art/detail remains the visual gate | P0 |
| World | Hardcoded river collision | PASSED | Water TileSet physics plus world-owned landmark/boundary collision; no player river exception | P0 |
| NPC | Mara / Rowan | IN_PROGRESS | Mara now has authored routine positions, identity ornament, relationship state and post-Echo dialogue; Rowan remains to be deepened | P1 |
| Echo | First Echo presentation | IN_PROGRESS | Old Road Echo now changes world presentation, unlocks continuity and drives Mara response; final cinematic presentation remains | P1 |
| Audio | Hearthfall vertical-slice score | IN_PROGRESS | Authored note motifs now cover exploration, Echo, fishing, crafting, home and Sleeping Gate; final recorded assets remain a later audio gate | P0 |
| Combat | Sleeping Gate encounter | IN_PROGRESS | Three authored enemy variants, health bars, hit-stun, telegraphs, knockback and encounter progression are integrated; final VFX/audio remain | P1 |
| Save | Current small save payload | IN_PROGRESS | Versioned, atomic, corruption-safe save with migration tests and persisted world state | P1 |
| VFX | Slice feedback language | IN_PROGRESS | Gather, fish, Echo and combat feedback have authored shapes/timing; final pixel-art VFX pass remains | P1 |
| QA | Vertical Slice 1.0 regression | IN_PROGRESS | Clean-save, TileMap physics, Echo, hero assets and migration checks are automated; real player first-run review remains | P1 |

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