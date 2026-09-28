# Everdune Canonical System Map

Status: LOCKED for the Repository + Architecture Consolidation Pass.

The repository has one canonical owner for each class of truth. New work must extend the owner rather than create parallel implementations.

| Concern | Canonical owner | Rule |
|---|---|---|
| Product identity / lore | docs/GENESIS.md + docs/FREE_PLAY_FOUNDATION.md | No contradictory lore; free-play promise is canonical |
| Visual language | docs/PIXEL_ART_BIBLE.md | Supplied visual master remains the bar |
| Engine / stack | docs/STACK_LOCK.md | Godot 4.7.2-stable |
| Architecture | docs/TECHNICAL_FOUNDATION.md | Simulation → State → Presentation |
| Production policy | docs/PRODUCTION_RULES.md | Data-driven, testable, explicit placeholders |
| Quality | docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md | Slice must pass before breadth |
| Placeholder debt | docs/PLACEHOLDER_REGISTRY.md | Temporary work is visible and retired explicitly |
| Game orchestration | game/scripts/main.gd | Wiring only; no new content databases |
| Game state | game/scripts/game_state.gd | Runtime progression state |
| Save format | game/scripts/save_system.gd | Versioned persistence + migrations |
| Content registry | game/scripts/content_registry.gd | Loads canonical Resources |
| Echo content | game/data/echoes + scripts/systems/echo_system.gd | Data owns authored content; system owns rules |
| NPC content | game/data/npcs + scripts/systems/npc_system.gd | Data owns authored content; system owns rules |
| World locations | game/data/locations + scripts/systems/location_system.gd | Coordinates are content data |
| Interaction routing | game/scripts/systems/interaction_system.gd | Nearest interaction selection |
| Gathering | game/scripts/systems/gathering_system.gd | Resource reward/progression rules |
| Crafting | game/scripts/systems/crafting_system.gd | Crafting orchestration |
| Combat | game/scripts/systems/combat_system.gd | Combat rules; presentation remains separate |
| Free-play activities | game/scripts/systems/freeplay_system.gd | Player-led cooking, farming, building, decorating and wayfinding |
| World presentation | game/scripts/world_tiles.gd | TileMapLayer + authored world dressing |
| Player | game/scripts/player.gd | Movement, animation and player presentation |
| UI | game/scripts/ui.gd | Presentation/input intent only |
| Weather | game/scripts/weather.gd | Environmental presentation |
| Audio | game/scripts/audio.gd | Audio presentation |
| Settings | game/scripts/settings.gd | Persistent player preferences |
| Assets | game/assets + assets/ASSET_MANIFEST.json | Every runtime asset is catalogued |
| Validation | tools/validate_repo.py | Repository-level integrity |
| Regression | game/tests/ | Deterministic runtime checks |
| Browser shell | game/web + web/ | Godot runtime, not a second game |
| CI | .github/workflows | Build + export + regression authority |

## Dependency direction

Content data → gameplay systems → GameState → presentation.

Player-led progression follows the same direction: location/data → activity system → persistent state → world/NPC presentation.

Presentation may emit player intent through signals. It must not become a second gameplay authority.

main.gd is an orchestrator. If a new feature requires a large amount of logic in main.gd, create or extend a system/data owner instead.

## Retirement rule

Obsolete implementations are deleted once the canonical replacement is verified. CI must fail if a retired path reappears.
