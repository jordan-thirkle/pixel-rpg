# Godot Game Runtime

This directory is the actual Everdune game.

## Locked runtime

- Godot **4.7.2-stable**
- GDScript
- Native Godot 2D runtime
- Pixel-first presentation
- Data-driven game state
- GitHub Actions headless validation

Do not replace the runtime with an HTML/Canvas prototype.

## Current vertical slice

The runtime currently proves:

1. Enter Larkmere Valley.
2. Move with WASD / arrow keys.
3. Gather wood and stone.
4. Fish at the river.
5. Talk to Mara and Rowan.
6. Discover the Old Road Echo.
7. Gain XP and levels.
8. Open inventory.
9. Craft a Hearth Lamp.
10. Rest at home.
11. Save and load the local game state.

## Controls

- **WASD / Arrow keys:** move
- **E:** interact
- **I:** inventory
- **C:** craft while inventory is open
- **K:** save
- **L:** load
- **Space:** prototype combat action
- **Esc:** close panels

This is the first real runtime slice, not the final art pass. The next production step is replacing procedural placeholder drawing with the canonical pixel asset pipeline while preserving the gameplay/state contracts.
