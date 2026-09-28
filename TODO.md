
# EVERDUNE — LIVE TODO / EXECUTION QUEUE

Last reviewed: 2026-09-28
Evidence update: repository contracts pass, but the prior deployment/site was not a credible player-facing product. P0 is now public runtime + authored visual quality before deeper content.
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

## [x] Consolidate production art/audio + systemic free-play work
Evidence: main already contains the production hero layer set, Sleeping Gate asset, authored audio layer, combat telegraphs and the systemic free-play foundation. The divergent production branch was audited and its stale free-play-sensitive runtime replacements were not merged.

# P0 — CANONICAL DOCUMENTATION

## [x] Create PROJECT.md
Permanent product and engineering source of truth.

## [x] Create TODO.md
Live execution queue for all AI development.

## [x] Port canonical AI agent contract into main
Target: docs/AI_AGENT_CONTRACT.md
Required: source-of-truth first, canonical owner, no duplicate authority, data → systems → state → presentation, verification required, TODO update required.

## [x] Port canonical system map into main
Target: docs/SYSTEM_MAP.md

## [x] Port production rules into main
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

## [!] Complete the first-session journey
Boot → Title → Creator → Hearthfall → Mara → Gather → Fish → Old Road Echo → Mara return → Glass Orchard Echo → Craft → Sleeping Gate → Combat → Home

Acceptance: no fake presentation, movement feels excellent, interactions are tactile, first Echo feels magical, return home feels rewarding. Blocked until the real public browser build is anonymously reachable and visually verified.

## [!] Finish Hearthfall visual environment gate
Production feel/atmosphere foundations are present on main, but the shipped result is still prototype-grade. Replace concept/prototype presentation with authored production composition, depth, lighting and readable silhouettes.

## [~] Finish props / terrain atlas
Current atlas is a technical prototype. Production pass must establish coherent palette, density, pivots, readable silhouettes and authored landmark variants.

## [~] Finish title screen
Real Godot title/loading foundation exists; remaining work is production art direction, typography, transition and final browser QA.

## [ ] Finish character creator
Must use the real production hero assets and remain fast and expressive.

## [x] Finish Mara + Rowan production pass
Mara and Rowan now have authored routines; activity-aware dialogue is data-driven, and Rowan responds to remembered world/gathering discoveries.

## [x] Finish first Echo presentation
Echo discovery now has an authored reveal layer, audio, burst FX, persistent environmental response and dialogue.

## [~] Finish Sleeping Gate
Existing: landmark, encounter loop, variants, telegraphs, hit-stun, health bars and progression.
Remaining: final VFX, balance, readability and experiential QA.

# P0 — PLAYER FREEDOM / LARKMERE DEPTH

## [x] Fishing depth pass
Target chain:
fish → cooking → food → gifts → relationship → trophy → home → river knowledge → Echo → return

Current pass: fishing skill progression, three catch profiles, dawn/dusk/rain weighting, cast/bite/reel feedback, miss feedback and cooking integration. Remaining: trophy progression, NPC requests and final QA.

## [x] Gathering depth
Woodcutting, mining and foraging now have skill-sensitive yield mastery, remembered first-use knowledge, deterministic experienced-gatherer memory finds, and local mastery feedback. Final playthrough QA remains.

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

## [~] Expand world-memory vocabulary
Echoes now leave persistent visual state; continue extending the same vocabulary only where it creates a visible player consequence.

## [ ] Add cross-system consequences
Every major activity should connect to at least one NPC, home, Echo, route, resource or lore consequence.

# P1 — NPC LIVES

## [x] Daily routines
Mara and Rowan both move through authored morning/day/evening positions.

## [x] Rowan foundation
Rowan now has a daily route, evening identity and post-Echo response.

## [x] Activity preferences
Mara and Rowan respond to repeated fishing, woodcutting, mining and foraging activity through authored data.

## [ ] NPC-to-NPC world activity
NPCs should appear to have lives even without player input.

## [ ] Relationship milestones
Unlock knowledge, dialogue, gifts, visits, world changes and home moments.

# P1 — ECHOES

## [~] Systemic Echo data model
Supports activity prerequisites, experience, unlock flags, world memory and relationship consequences; Hearthfall now has a local belonging Echo that connects cooking, home and Mara.

## [~] Chained Echoes
Foundation includes River Song, Miner's Ledger and Hollow Steps.

## [ ] Build Echo family chains
Each major Larkmere area should have a small network rather than one isolated collectible.

## [ ] Improve Echo presentation
Visual language, audio motif, environmental response, discovery animation and emotional payoff.

# P1 — HOME

## [x] Persistent home state
Home level, displays, garden state and home identity exist and now restore into the world presentation.

## [~] Room-level personalisation
Existing functional stations, meals, trophies, maps, decorations and Echo-linked displays now become persistent visual home records. Further room variety remains.

## [~] Emergent home identity
Different activity/display choices already alter the visible home; deeper variation remains after density QA.

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

Hearthfall: activities [~], NPC [x], Echo [x], secret [ ], restoration [~], return [~]
Silverrun: activities [~], NPC [~], Echo [~], secret [ ], restoration [ ], return [~]
Briarwood: activities [~], NPC [ ], Echo [ ], secret [ ], restoration [ ], return [~]
Old Road: activities [~], NPC [~], Echo [~], secret [ ], restoration [~], return [~]
Bellroot: activities [~], NPC [~], Echo [~], secret [~], restoration [ ], return [~]
Glass Orchard: activities [~], NPC [~], Echo [~], secret [ ], restoration [~], return [~]
Hollow Steps: activities [~], NPC [~], Echo [~], secret [~], restoration [ ], return [~]
Sleeping Gate: activities [~], NPC [ ], Echo [ ], secret [~], restoration [ ], return [~]

Do not start a second region until this table is genuinely dense.

# P1 — FEEL / POLISH

## [x] Movement feel pass
Acceleration/braking and grounded animation are present; interaction/activity actions now use the authored player action response.

## [~] Interaction feedback pass
Prompt transitions and gathering/fishing action feedback are now tactile. Remaining: final QA across NPCs, Echoes, activities and combat.

## [x] Fishing feel pass
Cast → bite → reel timing, audio/VFX, miss feedback and species/time/weather behavior are implemented; remaining polish is QA.

## [~] Gathering feel pass
Contact animation, authored gather cue, resource response, mastery pulse and respawn timing are present. Final player-facing QA remains.

## [ ] Echo feel pass
Anticipation, reveal, world response, sound motif and emotional punctuation.

## [ ] Combat feel pass
Readable attacks, hit feedback, enemy response, player response, telegraphs and satisfying defeat.

# P1 — QA

## [x] Deterministic foundation suite
Foundation regression path is green in CI.

## [ ] Full clean-save playthrough
One complete run from title to home return.

## [~] 45-minute free-play test
Automated foundation and Vercel-ready checks pass on the current main commit, including headless Godot startup and deterministic vertical-slice/save tests. A genuine 45-minute self-directed player session still requires interactive runtime observation; do not mark complete from CI alone.
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

NEXT TASK: Echo environmental consequences.

Gathering depth and the Mara + Rowan lives pass are implemented on the canonical branch. Do not add breadth.

Then execute:
1. Echo environmental consequences;
3. home personalisation;
4. Hearthfall/Larkmere density;
5. 45-minute self-directed free-play QA;
6. Vertical Slice 1.0 final gate;
7. only then expansion.

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
