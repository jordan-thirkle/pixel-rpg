# TECHNICAL FOUNDATION

## Target

Single-player-first premium Steam RPG with future cooperative multiplayer.

## Principle

Separate **game simulation/state** from **transport**.

Single-player:
- local authority

Future co-op:
- host authority / shared simulation

The same state model should cover:
- player
- world
- inventory
- equipment
- skills
- quests
- NPC state
- buildings
- containers
- resources
- weather
- time
- discoveries

## Prototype target

The first meaningful vertical slice should support:

character creation → Hearthfall → movement → gathering → crafting → fishing → NPC interaction → Echo discovery → home/restore action → save/load.

## Engine direction

Godot 4.x is the current preferred engine direction for the 2D pixel-first game.

The architecture should remain data-driven and AI-friendly.

## AI production

AI agents may create code/content/assets, but each output must be validated against the source of truth and automated checks before becoming canonical.
