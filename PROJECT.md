
# EVERDUNE — PROJECT SOURCE OF TRUTH

Status: ACTIVE DEVELOPMENT
Date: 2026-09-28
Canonical branch: main
Engine: Godot 4.7.2-stable

If another document, branch, prompt, agent memory or conversation conflicts with this file, stop and reconcile the conflict before implementation. Do not silently invent a third direction.

## 1. PRODUCT NORTH STAR

The promise is: The World Remembers.

Everdune is a quiet fantasy RPG where the player is a wayfarer living in Larkmere Valley. The player is free to fish, farm, forage, mine, craft, build, decorate, explore, fight, befriend people, discover Echoes or simply wander.

The core differentiator is persistent consequence.

A player should be able to say: “Tonight I'm going fishing.” The game should naturally connect that choice to skill mastery, cooking, rare catches, NPC memories, home displays, river knowledge, Echoes, map clues and future reasons to return without forcing a quest chain.

Core loop:

WORLD → ACTIVITY → SKILL → MATERIAL / KNOWLEDGE → RELATIONSHIP / HOME / WORLD CHANGE → NEW POSSIBILITY → RETURN

Every major activity should ideally produce:
1. immediate progress;
2. long-term progress;
3. world progress.

The player is a wayfarer, not a chosen one. Quiet play is first-class. Combat is optional.

## 2. LOCKED PRODUCT ORDER

ARCHITECTURE → FREEZE
TECHNICAL FOUNDATION → STABLE
PLAYER FREEDOM → BUILD DEEPLY
SKILLS → BUILD DEEPLY
ACTIVITIES → BUILD DEEPLY
WORLD CONSEQUENCE → BUILD DEEPLY
NPC LIVES → BUILD DEEPLY
ECHOES → MAKE THEM SYSTEMIC
HOME → MAKE IT PERSONAL
LORE → MAKE IT PAY OFF
CONTENT → MAKE LARKMERE DENSE
VERTICAL SLICE → PASS QUALITY GATE
EXPANSION → ONLY AFTER THE ABOVE

Do not reverse this order because adding a new feature is easier than finishing an existing one.

## 3. ARCHITECTURE — FROZEN

Invariant:

Content Data → Gameplay Systems → GameState → Presentation

Canonical owners:
- Product identity / lore: docs/GENESIS.md
- Visual language: docs/PIXEL_ART_BIBLE.md
- Engine / stack: docs/STACK_LOCK.md
- Architecture: docs/TECHNICAL_FOUNDATION.md
- Production policy: docs/PRODUCTION_RULES.md
- System ownership: docs/SYSTEM_MAP.md
- Gameplay orchestration: game/scripts/main.gd
- Runtime state: game/scripts/game_state.gd
- Saves: game/scripts/save_system.gd
- Content loading: game/scripts/content_registry.gd
- Echo rules: game/scripts/systems/echo_system.gd
- NPC rules: game/scripts/systems/npc_system.gd
- Location rules: game/scripts/systems/location_system.gd
- Interaction routing: game/scripts/systems/interaction_system.gd
- Gathering: game/scripts/systems/gathering_system.gd
- Crafting: game/scripts/systems/crafting_system.gd
- Combat: game/scripts/systems/combat_system.gd
- World presentation: game/scripts/world_tiles.gd
- UI: game/scripts/ui.gd
- Player: game/scripts/player.gd
- Audio: game/scripts/audio.gd
- Weather: game/scripts/weather.gd
- Assets: game/assets/ and assets/ASSET_MANIFEST.json
- Validation: tools/validate_repo.py
- Regression: game/tests/

Forbidden:
- no second world renderer;
- no parallel gameplay authority;
- no hardcoded content database in main.gd;
- no duplicate system for an existing responsibility;
- no generic replacement where an approved canonical asset exists;
- no hidden placeholder;
- no architecture rewrite merely to accelerate one feature;
- no new region until Larkmere depth passes its gate.

## 4. AI DEVELOPMENT OPERATING MODEL

AI is used to compress development time, not lower quality.

Every agent MUST:
1. read PROJECT.md;
2. read TODO.md;
3. identify the active task;
4. read the canonical owner;
5. inspect existing implementation;
6. make the smallest coherent change that advances the task;
7. run relevant validation;
8. update TODO.md with evidence/status;
9. update documentation when the contract changes;
10. stop when the task is complete.

Safe parallel work:
- art;
- audio;
- documentation;
- isolated data resources;
- tests;
- QA;
- website shell.

Do not parallel-edit shared state, main orchestration, core systems, save schema, shared contracts or the same asset.

Every handoff must state:
- task;
- canonical owner;
- files changed;
- acceptance criteria;
- validation;
- remaining risk;
- next task.

## 5. QUALITY GATES

Technical:
- Godot parses;
- deterministic regression passes;
- save migration passes;
- save round-trip passes;
- asset manifest passes;
- web export passes;
- website integration passes.

Experiential:
- movement;
- interaction;
- gathering;
- fishing;
- crafting;
- combat;
- NPC presentation;
- Echo discovery;
- home return;
- audio;
- UI;
- visual hierarchy;
- atmosphere.

Product:
- player can choose an activity without a quest;
- player makes meaningful progress;
- player discovers a connected possibility;
- player sees consequence;
- player can return later and notice continuity.

Expansion:
- Larkmere is dense;
- 45-minute self-directed session passes;
- P0 visual debt is resolved;
- vertical slice gate passes;
- state/save architecture is stable.

## 6. LARKMERE CONTRACT

Every important location should eventually contain:

place + resource + skill + person + story + Echo + secret + restoration + reason to return

Locations:
- Hearthfall
- Silverrun
- Briarwood
- Old Road
- Bellroot Mine
- Glass Orchard
- Hollow Steps
- Sleeping Gate

Do not expand the map simply because content is needed. Deepen existing locations first.

## 7. SKILLS

Gathering, Woodcutting, Mining, Foraging, Fishing, Farming, Cooking, Crafting, Building, Wayfinding, Memory, Combat.

Skills are lenses over the same world, not isolated minigames.

## 8. ECHOES

Echoes are systemic memories, not lore cards.

A strong Echo can reveal history, change a location, unlock a route/activity, alter dialogue or relationships, create a home artefact, alter resource behaviour, unlock another Echo, or change the player's understanding of Larkmere.

Echo chains should emerge from lived activity.

## 9. NPC LIVES

Important NPCs require:
- routines;
- favourite places;
- relationships;
- memories;
- personal goals;
- contextual dialogue;
- weather/time response;
- world-change response.

NPCs are not quest terminals.

## 10. HOME

The home is the player's autobiography.

Home progression should be functional, visual, collectible, social and historical.

Different playstyles should naturally create different homes.

## 11. LORE CANON

Hearthsong is a natural resonance created by repeated acts of care, belonging and memory.

The Quieting was caused by failed attempts to centralise and control Hearthsong.

Wayfarers are listeners who notice Hearthsong rather than command it.

The player is not destined to restore an old centralised order.

The eventual question is:

What kind of memory did you help this place become?

Progress must leave evidence in the world.

## 12. REPOSITORY OPERATING MODEL

The repository currently contains historical parallel branches from architecture, vertical-slice, art/audio and free-play work. This is repository debt, not multiple product directions.

The desired end state is:

main → short feature branch → CI → QA → merge → delete branch → next task

Branch naming:
feat/<area>-<task>

Never create date-stamped mega branches or competing “final” branches.

## 13. AI-ACCELERATED TIMELINE

AI should compress development through:
- parallel asset production;
- parallel QA;
- automated regression;
- rapid documentation;
- deterministic content pipelines;
- agent handoffs;
- reusable systems;
- rapid iteration.

Speed must not come from skipping QA, accepting placeholders, duplicating architecture, or expanding scope prematurely.

Objective:

maximum validated progress per development hour.

## 14. DEFINITION OF DONE

A task is DONE only when:
- implementation exists;
- canonical owner is correct;
- no duplicate authority was introduced;
- tests/validation pass;
- relevant UX/product behaviour is verified;
- placeholder status is updated;
- TODO.md is updated;
- no known critical regression remains.

Code exists is not DONE.
CI is green is not necessarily DONE.
Looks okay is not evidence.

## 15. CURRENT MILESTONE

LARKMERE DEPTH + VERTICAL SLICE COMPLETION

The immediate priority is to prove that the existing valley supports a compelling self-directed session, finish the player-facing quality gates, remove P0 placeholder debt, validate the complete slice, and only then build expansion content.
