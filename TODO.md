
# EVERDUNE — LIVE TODO / EXECUTION QUEUE

Last reviewed: 2026-09-28
Rule: work from the top. Do not skip ahead because a lower item is more exciting.

Legend: [ ] not started, [~] active, [x] complete, [!] blocked, [?] needs evidence.

# P0 — REPOSITORY / TEAM CONTROL

## [x] Freeze architecture
Godot architecture remains canonical. No second renderer. No new gameplay authority. No new region.

## [~] Consolidate repository branches
Known branches:
- main
- consolidation-architecture-2026-09-27
- depth-first-larkmere-pass
- everdune-freeplay-depth-2026-09-28
- everdune-hearthfall-art-upgrade-2026-09-27
- everdune-hearthfall-slice-1-0-2026-09-27
- everdune-production-art-audio-qa-2026-09-28
- everdune-status-sync-2026-09-27
- everdune-website-concept-pass-2026-09-27
- hearthfall-feel-pass-2026-09-27

Decision: preserve useful work, then retire branch proliferation.

## [x] Close obsolete depth PR
PR #9 was closed after the direct-to-main route proved unsuitable for repository consolidation.

## [~] Consolidate production art/audio + systemic free-play work
Required:
1. preserve production hero/audio/combat work;
2. preserve systemic free-play work;
3. preserve canonical architecture;
4. run full CI;
5. merge only the verified result into main.

# P0 — CANONICAL DOCUMENTATION

## [x] Create PROJECT.md
Permanent product and engineering source of truth.

## [x] Create TODO.md
Live execution queue for all AI development.

## [ ] Port canonical AI agent contract into main
Target: docs/AI_AGENT_CONTRACT.md
Required: source-of-truth first, canonical owner, no duplicate authority, data → systems → state → presentation, verification required, TODO update required.

## [ ] Port canonical system map into main
Target: docs/SYSTEM_MAP.md

## [ ] Port production rules into main
Target: docs/PRODUCTION_RULES.md

## [ ] Reconcile roadmap documents
Reconcile:
- docs/ROADMAP_2026_PLUS.md
- docs/FREE_PLAY_FOUNDATION.md
- docs/LARKMERE_CONTENT_PLAN.md
- docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md
- PROJECT.md
- TODO.md

# P0 — VERTICAL SLICE

## [~] Complete the first-session journey
Boot → Title → Creator → Hearthfall → Mara → Gather → Fish → Old Road Echo → Mara return → Glass Orchard Echo → Craft → Sleeping Gate → Combat → Home

Acceptance: no fake presentation, movement feels excellent, interactions are tactile, first Echo feels magical, return home feels rewarding.

## [ ] Finish Hearthfall visual environment gate
Need authored pixel-art terrain, landmark readability, depth, lighting and environmental storytelling.

## [ ] Finish props / terrain atlas
Need production asset set with coherent palette, density, pivots, readable silhouettes and landmark variants.

## [ ] Finish title screen
Need immediate identity, atmosphere, hierarchy and fast entry.

## [ ] Finish character creator
Must use the real production hero assets and remain fast and expressive.

## [~] Finish Mara + Rowan production pass
Mara has the stronger foundation. Rowan needs deeper routine, identity, dialogue and world responses.

## [~] Finish first Echo presentation
System exists. Remaining: cinematic presentation, stronger audio/VFX, environmental response and emotional payoff.

## [~] Finish Sleeping Gate
Existing: landmark, encounter loop, variants, telegraphs, hit-stun, health bars and progression.
Remaining: final VFX, balance, readability and experiential QA.

# P0 — PLAYER FREEDOM / LARKMERE DEPTH

## [~] Fishing
Target chain:
fish → cooking → food → gifts → relationship → trophy → home → river knowledge → Echo → return

Current foundation includes fishing, skill progression, rare catch logic and Echo connection.
Next: species variety, weather/time behaviour, stronger feedback, cooking integration, trophy progression and NPC requests.

## [~] Gathering
Deepen woodcutting, mining and foraging with mastery, rare materials, environmental clues and consequences.

## [~] Farming
Deepen seasonal crops, useful produce, cooking, gifts, home visuals and orchard connection.

## [~] Crafting
Deepen meaningful recipes, resource decisions, functional upgrades and home displays. Avoid recipe spam.

## [~] Wayfinding
Deepen routes, shortcuts, maps, landmarks, lost places and historical Echoes.

## [~] Optional combat
Combat must feel good, reward mastery, remain optional and connect to Bellroot/Sleeping Gate.

# P1 — WORLD CONSEQUENCE

## [ ] Make restoration change NPC routines
Examples: repaired route, restored orchard, workshop, improved home.

## [ ] Make activity mastery visibly alter the world
Mastery should leave evidence beyond numbers.

## [ ] Expand world-memory vocabulary
World memories should describe meaningful state transitions.

## [ ] Add cross-system consequences
Every major activity should connect to at least one NPC, home, Echo, route, resource or lore consequence.

# P1 — NPC LIVES

## [~] Daily routines
Mara foundation exists.

## [~] Rowan foundation
Needs deeper authored life.

## [ ] Activity preferences
NPC responses should vary by player activity.

## [ ] NPC-to-NPC world activity
NPCs should appear to have lives even without player input.

## [ ] Relationship milestones
Unlock knowledge, dialogue, gifts, visits, world changes and home moments.

# P1 — ECHOES

## [~] Systemic Echo data model
Supports activity prerequisites, experience, unlock flags, world memory and relationship consequences.

## [~] Chained Echoes
Foundation includes River Song, Miner's Ledger and Hollow Steps.

## [ ] Build Echo family chains
Each major Larkmere area should have a small network rather than one isolated collectible.

## [ ] Improve Echo presentation
Visual language, audio motif, environmental response, discovery animation and emotional payoff.

# P1 — HOME

## [~] Persistent home state
Home level, displays, garden state and home identity exist.

## [ ] Room-level personalisation
Furniture, functional stations, trophies, maps, collections and Echo artefacts.

## [ ] Emergent home identity
Different players should naturally produce different homes.

## [ ] NPC home interactions
Visits, comments, gifts, memories and events.

# P1 — LORE

## [x] Establish Hearthsong / Quieting canon
Keep Hearthsong as distributed memory resonance, Quieting as failed centralisation and Wayfarers as listeners.

## [ ] Pay lore off through gameplay
Locations, objects, NPC memories, Echoes, restoration and home.

## [ ] Remove exposition dependency
Players should understand Everdune by living in it, not reading walls of text.

# P1 — LARKMERE DENSITY

Every important location should track:
place + resource + skill + person + story + Echo + secret + restoration + return reason

Hearthfall: activities [~], NPC [~], Echo [ ], secret [ ], restoration [~], return [~]
Silverrun: activities [~], NPC [~], Echo [~], secret [ ], restoration [ ], return [~]
Briarwood: activities [~], NPC [ ], Echo [ ], secret [ ], restoration [ ], return [~]
Old Road: activities [~], NPC [~], Echo [~], secret [ ], restoration [~], return [~]
Bellroot: activities [~], NPC [~], Echo [~], secret [~], restoration [ ], return [~]
Glass Orchard: activities [~], NPC [~], Echo [~], secret [ ], restoration [~], return [~]
Hollow Steps: activities [~], NPC [~], Echo [~], secret [~], restoration [ ], return [~]
Sleeping Gate: activities [~], NPC [ ], Echo [ ], secret [~], restoration [ ], return [~]

Do not start a second region until this table is genuinely dense.

# P1 — FEEL / POLISH

## [ ] Movement feel pass
Acceleration, stopping, turn responsiveness, collision and animation transitions.

## [ ] Interaction feedback pass
Every interaction must clearly communicate success, reward, meaning and change.

## [ ] Fishing feel pass
Anticipation, bite, reel, catch, miss, audio and VFX.

## [ ] Gathering feel pass
Contact animation, sound, particles, resource response and satisfying timing.

## [ ] Echo feel pass
Anticipation, reveal, world response, sound motif and emotional punctuation.

## [ ] Combat feel pass
Readable attacks, hit feedback, enemy response, player response, telegraphs and satisfying defeat.

# P1 — QA

## [x] Deterministic foundation suite
Foundation regression path is green in CI.

## [ ] Full clean-save playthrough
One complete run from title to home return.

## [ ] 45-minute free-play test
Player may ignore story, choose an activity, wander, change activities and return home.
Record dead time, confusion, friction, discoveries and visible consequences.

## [ ] 2-hour systems test
Exercise multiple skills, locations, NPCs, home progression, Echoes and optional combat.

## [ ] Save/reload continuity test
Verify skills, relationships, home, world memory, Echoes, activity state and seasonal state.

# P2 — EXPANSION

Blocked until P0/P1 product gates pass.

## [ ] Define second-region criteria
Reuse architecture, save model, content pipeline and Echo/NPC models.

## [ ] Define expansion content pipeline
New regions should primarily be data + authored assets + existing system rules.

## [ ] Gauntlet
Only after combat and Sleeping Gate are genuinely excellent.

## [ ] Long-term progression
Only after core activities are genuinely satisfying.

# BRANCH / PR POLICY

Canonical flow:
main → short feature branch → CI → QA → merge → delete branch → next task

Branch naming:
feat/<area>-<task>

Examples:
feat/fishing-species
feat/rowan-routine
feat/hearthfall-props
feat/echo-presentation

One PR = one coherent outcome.

Every PR includes:
- problem;
- implementation;
- validation;
- screenshots/evidence when visual;
- TODO update;
- placeholder update where applicable.

# CURRENT AI TEAM QUEUE

NEXT TASK: P0 repository consolidation.

Do not begin unrelated gameplay work until the repository has one canonical development line and the source-of-truth docs are available on that line.

Then execute:
1. vertical slice visual gate;
2. movement + interaction feel;
3. fishing depth;
4. gathering depth;
5. NPC lives;
6. systemic Echo presentation;
7. home personalisation;
8. Larkmere density;
9. 45-minute free-play QA;
10. Vertical Slice 1.0 final gate;
11. only then expansion.

# AGENT COMPLETION TEMPLATE

Task:
Owner:
Status: PASS / NEEDS WORK / BLOCKED
Files:
Validation:
Evidence:
Remaining risk:
Next task:

The next agent must be able to continue without reconstructing project history from chat.

# FINAL RULE

Do not build the game that is easiest for an AI to generate.

Build the game that is best for the player.

AI is the accelerator. Product vision, architecture, quality bar and player experience remain the authority.
