# Everdune — Placeholder Registry

Date: 2026-09-28

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
| Art | Hero body/hair/coat + production layer set | PASSED | 9-layer, 16-frame crisp-edge character sheet with unified silhouette, palette, shading, facial readability and movement coverage; validated by runtime regression and repository asset checks | P0 |
| Art | Props / terrain atlas | PLACEHOLDER | Production pixel-art atlas with validated density, palette, pivots and landmark-specific variants | P0 |
| UI | Title screen presentation | IN_PROGRESS | Beautiful, identity-defining title experience with clear hierarchy, atmosphere and tactile interaction | P0 |
| UI | Character creator | IN_PROGRESS | Fast, expressive creator with production hero preview and readable choices | P0 |
| World | Visible Hearthfall map | IN_PROGRESS | Multi-layer authored TileMap topology now drives ground, river and paths; landmark art/detail remains the visual gate | P0 |
| World | Hardcoded river collision | PASSED | Water TileSet physics plus world-owned landmark/boundary collision; no player river exception | P0 |
| NPC | Mara / Rowan | IN_PROGRESS | Mara now has authored routine positions, identity ornament, relationship state and post-Echo dialogue; Rowan remains to be deepened | P1 |
| Echo | First Echo presentation | IN_PROGRESS | Old Road Echo now changes world presentation, unlocks continuity and drives Mara response; final cinematic presentation remains | P1 |
| Audio | Hearthfall vertical-slice score | PASSED | Final original procedural score with named motifs for every gameplay event, dynamic day/night/Gate ambience, deterministic synthesis and runtime regression coverage | P0 |
| Combat | Sleeping Gate encounter | IN_PROGRESS | Three authored enemy variants, health bars, hit-stun, telegraphs, knockback and encounter progression are integrated; final VFX remains | P1 |
| Save | Current small save payload | IN_PROGRESS | Versioned, atomic, corruption-safe save with migration tests and persisted world state | P1 |
| VFX | Slice feedback language | IN_PROGRESS | Gather, fish, Echo and combat feedback have authored shapes/timing; final pixel-art VFX pass remains | P1 |
| QA | Production hero/audio regression | PASSED | Clean-save runtime checks, 16-frame hero-sheet validation, crisp-edge validation, complete audio motif coverage and deterministic Godot regression | P0 |
| QA | Vertical Slice 1.0 full product gate | IN_PROGRESS | Remaining visual gates: Hearthfall environment, props/terrain, title/creator, Mara/Rowan, Echo presentation, VFX and final player playtest | P0 |

## Production QA evidence — 2026-09-28

### Hero

The player character is now a complete nine-layer runtime stack:

1. back item
2. boots
3. trousers
4. shirt
5. body
6. face
7. coat
8. hair
9. accessory

Each layer is a 128×128 four-by-four sprite sheet containing 16 aligned crisp-edge frames. The layers share the same 32×32 cell grid, directional rows and animation cadence. The production validator rejects missing layers, incorrect dimensions, non-crisp rendering or incorrect frame counts.

The runtime player uses the same assets for movement and the character creator preview, so the creator cannot silently drift into a separate prototype character.

### Audio

The Hearthfall slice now uses a final original procedural score rather than anonymous placeholder tones.

Named motifs cover:
- gathering
- fishing cast
- fishing bite
- fishing catch
- fishing miss
- Echo discovery
- crafting
- UI
- level progression
- weapon swing
- hit
- defeat
- Sleeping Gate opening
- returning home

Ambient harmony changes between normal valley, night and Gate moods. The score is deterministic and authored as musical data, allowing the same identity to scale into later regions without replacing the audio architecture.

### Automated acceptance

The production regression suite now verifies:
- clean new-game state
- TileMapLayer topology
- bridge/water collision
- signature Echo progression
- save version
- all nine hero layers
- exact 16-frame sheet structure
- crisp-edge pixel rendering
- every named audio motif
- ambient audio layer
- Sleeping Gate asset presence

CI repository validation independently repeats the hero/audio contract, preventing a future commit from silently downgrading either gate.

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

The vertical slice remains the quality laboratory. Scale only after the remaining P0 visual gates pass.


## Free-play depth pass — 2026-09-28

The following are now canonical foundations rather than placeholders:

- skill family expanded to woodcutting, mining, foraging, fishing, farming, cooking, crafting, building, wayfinding, memory and combat;
- repeatable Larkmere activities for cooking, gardening, wayfinding, building and decorating;
- skill-specific gathering progression;
- persistent activity counts;
- persistent world memories;
- persistent NPC memories;
- persistent home level and display items;
- persistent garden state;
- systemic Echo metadata and world-memory consequences;
- Bellroot and Silverrun Echoes;
- dense Larkmere content plan;
- depth-first long-term roadmap.

These systems are intentionally foundation-depth, not a claim that the final commercial content quantity or presentation is complete.
