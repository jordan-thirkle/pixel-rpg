# Everdune — Ruthless Second-Eyes Audit
Date: 2026-09-27
Status: NOT A RELEASE GATE PASS

## Executive finding

The project has a real Godot/Web export pipeline and a functioning architectural foundation, but it is not yet the polished Everdune product previously specified. The largest remaining gap is not technology. It is the distance between the approved visual/product bar and the current authored runtime content.

The current build must be treated as an executable vertical-slice foundation, not as a near-finished game.

## P0 — must be true before calling the first-run gate complete

### 1. Reference artwork fidelity
Current state: FAIL.
The current Hearthfall SVG is a useful scene scaffold, but it is substantially simpler than the supplied visual master and the locked Cinematic Pixel Fantasy bible. It reads as constructed vector/pixel geometry rather than high-detail authored pixel art.

Required:
- canonical environment tiles and props at the approved pixel density
- richer texture/palette hierarchy
- real character silhouettes and animation
- authored lighting/shadows
- depth layers and environmental motion
- landmark-specific detail
- no generic substitute art

### 2. First-run flow
Current state: PARTIALLY PASSING; New Journey handoff was corrected in this audit.
Required final sequence:
real browser loading → real Godot resource loading → title presentation → New Journey/Continue → character creation with live preview → Hearthfall → immediate understandable control feedback.

No fake waits, fake percentages, fake readiness or dead UI.

### 3. Runtime must be visually real
Current state: IMPROVED, but FAIL as final visual gate.
The Godot runtime now contains actual authored scene artwork. However, the browser page still contains legacy CSS mock-game markup underneath the real iframe. It is not the source of gameplay, but it is dead presentation code and must be removed before the web surface is considered clean.

### 4. World architecture
Current state: PARTIAL.
A real TileMapLayer/TileSet system exists and is now instantiated beneath the authored scene. However, the current visible map is still primarily one authored scene image, and collision remains hardcoded in player logic.

Required:
- production-authored TileMapLayer world
- proper collision geometry
- authored transitions
- map chunks/regions
- data-driven landmarks
- no coordinate-only gameplay geography

### 5. Save system
Current state: IMPROVED.
Save versioning was previously declared but not actually migrated. A real version check/migration path is now present.

Required next:
- migration tests
- corrupted-save handling
- atomic write strategy
- save slot/profile decision
- world/entity state persistence beyond the current small state payload

## P1 — product quality

### Character
Current:
- directional movement
- layered body/hair/coat
- basic tool layer
- live creator preview

Missing:
- canonical high-detail hero
- face/expression system
- trousers/boots/accessory/back-item layers
- better animation timing
- attack/tool-specific authored animations
- equipment readability at gameplay scale
- NPC visual hierarchy

### World
Current:
- river
- village
- props
- trees
- garden
- fire
- blossom landmark
- authored composition

Missing:
- dense authored world detail
- believable spatial storytelling
- proper foreground occlusion
- environmental animation breadth
- weather depth
- reflections
- richer water
- production collision
- production-scale map topology

### NPCs and simulation
Current:
- two NPCs
- simple dialogue
- one time condition

Missing:
- schedules
- relationships
- routines
- location changes
- contextual dialogue
- memory/Echo reactions
- world-state consequences

### Echo system
Current:
- two hardcoded Echo interactions

Missing:
- reusable Echo data model
- evidence/memory presentation language
- multi-step discoveries
- object/place/person Echo types
- systemic world memory
- consequences that alter the world

### RPG progression
Current:
- XP
- level
- skills
- equipment state
- collections
- achievements

Missing:
- meaningful build choices
- equipment stats/modifiers
- item identity
- progression pacing
- balanced economy
- meaningful collection rewards

### Combat
Current:
- one enemy
- basic chase
- basic damage
- basic attack
- hit feedback

Missing:
- readable telegraphs
- hitstop/impact language
- attack arcs/ranges
- enemy variants
- status/defence logic
- encounter design
- boss design
- meaningful combat progression

### Gauntlet
Current: NOT BUILT.
This remains an explicit replayability/intensity system and cannot be considered optional merely because the main game is cozy.

### Audio
Current: runtime-generated placeholder cue layer.
FAIL against the intended product bar.

Required:
- authored music
- ambience
- biome audio
- footsteps
- tool sounds
- water/fire/weather
- NPC/dialogue cues
- combat impact
- dynamic layering

## P1 — AAA-style first impression

The startup flow needs another pass after the engineering correction.

Target:
1. brand/splash is brief and purposeful
2. actual loading is observable and truthful
3. title screen establishes place, tone and identity immediately
4. menu hierarchy is effortless
5. New Journey has a cinematic but fast creator flow
6. first gameplay frame communicates where the player is and what to do without an instruction dump
7. controls have immediate tactile feedback
8. first NPC interaction is authored, not a debug dialogue box
9. first Echo feels like the game's signature mechanic
10. first return-home moment establishes the emotional loop

The current title menu is structurally correct but visually and interactively below this bar.

## P2 — production systems

Still required:
- automated gameplay regression
- content data resources
- asset manifest enforcement
- pixel-art compiler/validator
- proper collision validation
- save migration tests
- deterministic content tests
- Steam platform adapter
- Steamworks integration
- achievements/Cloud Save strategy
- co-op transport boundary
- multiplayer-safe simulation
- analytics/telemetry strategy if desired
- localization architecture
- full accessibility pass
- controller/gamepad support
- key rebinding
- audio settings
- resolution/scaling options
- input prompts

## P3 — scale/replayability

Still required:
- procedural content framework
- controlled RNG
- collections
- secrets
- optional dungeons
- Gauntlet
- rare discoveries
- replayable progression
- seasonal/world-state content
- deeper NPC simulation
- additional regions
- world expansion pipeline

## Product truth

The project currently proves:
**we can build and export a real Godot game.**

It does NOT yet prove:
**we have built the polished commercial Everdune experience.**

The next work should therefore prioritise fidelity, feel, authored content and production-quality first-run UX over adding more systems for their own sake.

## Release-gate rule

Do not call the vertical slice complete until:
- the supplied visual master and the runtime are visually comparable
- the first-run experience is polished
- the playable world uses real authored game assets
- the world has proper collision
- the core Echo loop feels distinctive
- audio no longer sounds like runtime placeholders
- save/load survives migration/corruption tests
- the full regression journey passes
- the browser and native builds share the same gameplay source


## Active vertical-slice gate

The next major product gate is `docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md`. Temporary work is governed by `docs/PLACEHOLDER_REGISTRY.md`; no knowingly temporary implementation may become invisible technical debt.
