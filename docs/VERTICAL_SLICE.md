# Everdune Vertical Slice

## Milestone
The first real game runtime is now implemented in Godot.

## Acceptance loop
- [x] Character runtime
- [x] Hearthfall presentation
- [x] Movement
- [x] Resource gathering
- [x] Fishing interaction
- [x] NPC dialogue
- [x] Echo discovery
- [x] XP / level progression
- [x] Inventory
- [x] Hearth Lamp crafting
- [x] Home/rest
- [x] Save/load
- [x] Deterministic keyboard controls
- [x] CI headless project validation
- [x] Real TileMapLayer terrain
- [x] Imported pixel asset atlases
- [x] Layered player visual customisation
- [x] Character creation persistence
- [x] Reusable gathering nodes with respawn
- [x] Actionable crafting UI
- [x] Weather overlay and day/night ambience
- [x] Dynamic local light presentation
- [x] Two-stage Echo progression
- [x] Replaceable runtime audio cue layer
- [~] Art foundation integrated; final canonical art fidelity is not yet achieved
- [~] Authored dressing/UI foundation; final density and polish remain
- [x] Lightweight gather/Echo VFX feedback
- [x] Four-direction hero animation
- [x] Visible equipment/tool action layer
- [x] Animated river surface
- [x] Environmental fire/foliage dressing
- [x] Skill progression and persistent equipment state
- [x] Collections and achievement tracking
- [x] Quest-stage progression beyond the initial Echo
- [x] First combat enemy with chase/damage/defeat
- [x] Sleeping Gate combat trial
- [~] Runtime audio identity layer; final authored music/audio remains

## Intentional limitations
This is not the final game and does not pretend to be. It establishes the executable contract that later art/content systems build on.

Not yet production-complete:
- higher-detail canonical hero art and authored animation
- TileMapLayer-authored production map
- proper collision geometry for the full world
- final authored audio/music assets
- expanded combat, dungeon design and boss encounters
- full quest/content library beyond the vertical slice
- expanded equipment and character customisation (core layered equipment/customisation now exists; production breadth remains)
- procedural content systems
- Gauntlet
- Steamworks
- multiplayer transport
- accessibility/settings/options (initial runtime settings now exist; full accessibility pass remains)
- final save migration/versioning
- automated gameplay regression suite

Those systems should be added as vertical slices, not as disconnected feature piles.

## Current production gate

The project has crossed from technical prototype into executable production-runtime territory, but it has not crossed the commercial visual-quality gate. Visual fidelity, content depth, collision, audio and first-run polish are still being raised in deliberate passes. The current assets are integrated and replaceable; they are not the final art ceiling.

Next gate: **Everdune Vertical Slice Quality Gate** (`docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md`)

The existing 20–30 minute journey is now the quality laboratory. Work proceeds through the full player-facing chain rather than feature-by-feature expansion. Every knowingly temporary implementation is tracked in `docs/PLACEHOLDER_REGISTRY.md`.

Priority order:
1. real loading → beautiful title → excellent character creation
2. first Hearthfall frame → movement feel → authored/alive world
3. Mara characterisation → satisfying gathering/fishing
4. signature Echo → meaningful crafting
5. dramatic Sleeping Gate → satisfying combat
6. emotionally satisfying return home
7. only then scale the world and replayability systems


## 20–30 minute vertical-slice target

The current production slice is now structured as a complete short-form player journey:

**Create Wayfarer → Hearthfall → meet Mara/Rowan → gather → fish → discover Old Road Echo → return to Mara → reach Glass Orchard → craft Hearth Lamp → follow the awakened memory → discover Sleeping Gate → optional combat trial → clear the chamber → return home.**

The architecture intentionally leaves the player free to fish, gather, explore and return home rather than forcing combat. The Sleeping Gate is the first explicit high-intensity branch.

Production-quality expansion now focuses on replacing placeholder-quality art/audio with authored final assets while preserving this executable content spine.


## Browser deployment gate

The Godot Web export is now generated during the Vercel build and published under `/game/`. The public `/play/` shell and homepage game frame both target that generated runtime. This keeps the playable browser build derived from the same Godot source rather than maintaining a second HTML game.
