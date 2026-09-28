# Everdune Canonical System Map

Status: LOCKED

| Concern | Canonical owner |
|---|---|
| Product / lore | docs/GENESIS.md |
| Visual language | docs/PIXEL_ART_BIBLE.md |
| Stack | docs/STACK_LOCK.md |
| Production rules | docs/PRODUCTION_RULES.md |
| Project direction | PROJECT.md |
| Execution queue | TODO.md |
| Orchestration | game/scripts/main.gd |
| State | game/scripts/game_state.gd |
| Save | game/scripts/save_system.gd |
| Content registry | game/scripts/content_registry.gd |
| Echo | game/scripts/systems/echo_system.gd |
| NPC | game/scripts/systems/npc_system.gd |
| Locations | game/scripts/systems/location_system.gd |
| Interaction | game/scripts/systems/interaction_system.gd |
| Gathering | game/scripts/systems/gathering_system.gd |
| Crafting | game/scripts/systems/crafting_system.gd |
| Combat | game/scripts/systems/combat_system.gd |
| World presentation | game/scripts/world_tiles.gd |
| Player | game/scripts/player.gd |
| UI | game/scripts/ui.gd |
| Audio | game/scripts/audio.gd |
| Weather | game/scripts/weather.gd |
| Assets | game/assets + assets/ASSET_MANIFEST.json |
| Validation | tools/validate_repo.py |
| Regression | game/tests |
| Web shell | web/ + game/web |

Dependency direction:
Content data → gameplay systems → GameState → presentation.

Presentation may emit player intent but must not become a second gameplay authority.

main.gd is orchestration. Substantial new gameplay logic belongs in a canonical system/data owner.
