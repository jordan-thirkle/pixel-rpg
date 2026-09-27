# AI Agent Contract

Every AI implementation task must identify the canonical owner, existing system to extend, allowed files, verification method, and affected quality/placeholder gate before editing.

## Safe pattern

Data → system → state → presentation.

- New Echo → game/data/echoes + Echo system.
- New NPC → game/data/npcs + NPC system.
- New location → game/data/locations + location/interaction system.
- New visual → canonical asset path + manifest + visual QA.

## Forbidden

Do not add hardcoded content databases to main.gd.
Do not create a second world renderer.
Do not replace canonical visual references with generic substitutes.
Do not mark a placeholder complete because code executes.

## Completion

Code, data, validation and documentation must agree before a task is considered complete.
