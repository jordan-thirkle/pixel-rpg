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

## Intentional limitations
This is not the final game and does not pretend to be. It establishes the executable contract that later art/content systems build on.

Not yet production-complete:
- canonical sprite sheets and animation
- TileMapLayer-authored production map
- proper collision geometry for the full world
- audio/music
- complete combat
- quests/objectives beyond the first Echo
- equipment and character customisation
- procedural content systems
- Gauntlet
- Steamworks
- multiplayer transport
- accessibility/settings/options
- final save migration/versioning
- automated gameplay regression suite

Those systems should be added as vertical slices, not as disconnected feature piles.