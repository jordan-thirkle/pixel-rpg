# Everdune Depth-First Production Contract

Status: ACTIVE — 2026-09-28

The architecture is frozen. The product is no longer allowed to respond to a content problem by introducing another framework, renderer or parallel gameplay authority.

The next production stage is depth inside Larkmere.

## Order of work

Architecture → freeze

Technical foundation → stable

Player freedom → build deeply

Skills → build deeply

Activities → build deeply

World consequence → build deeply

NPC lives → build deeply

Echoes → make them systemic

Home → make it personal

Lore → make it pay off

Content → make Larkmere dense

Expansion → only after the above

This is a production order, not a feature wishlist.

## The freedom contract

A player must be able to launch after a stressful day, ignore the story, choose one small activity and naturally discover other meaningful possibilities without being pushed down a questline.

The intended systemic loop is:

**world → activity → skill → material/knowledge → relationship/home/world change → new possibility → return**

Every repeatable activity should create:

1. immediate value;
2. persistent mastery or collection progress;
3. at least one possible connection into the rest of the valley.

## The ten-reasons rule

A player saying “tonight I am going fishing” should encounter reasons to continue only when the world naturally presents them.

Fishing can lead to weather-dependent catches, cooking, trophies, NPC dialogue, river Echoes, map clues, rare knowledge and return reasons. The player chooses which thread to follow.

The same rule applies to woodcutting, mining, foraging, farming, cooking, crafting, building, wayfinding and optional combat.

## Persistent consequence contract

Player-led actions must leave evidence where practical.

Examples:

- a mapped route becomes a usable route;
- a tended orchard visibly produces again;
- a market trade changes what the player can plant;
- a crafted object becomes part of the home;
- repeated mastery changes what a skill can yield;
- an Echo changes knowledge, dialogue, access or presentation;
- NPCs remember interactions and develop relationship state.

A number changing in a HUD is not sufficient evidence of consequence.

## NPC life contract

NPCs are not quest terminals.

Each important NPC needs:

- a routine;
- places they prefer;
- relationships;
- memories;
- a personal goal;
- contextual dialogue;
- responses to weather/time;
- responses to player-caused world changes.

The simulation should answer “where are they?” from the world state rather than from a quest step.

## Echo contract

Echoes are systemic memories.

An Echo may depend on an activity the player has actually lived through. Discovering it can:

- teach knowledge;
- unlock a route;
- unlock an activity;
- alter a relationship;
- alter the world;
- create a later Echo;
- change dialogue;
- create a home artefact;
- change how another system behaves.

Echo chains should reward curiosity rather than checklist completion.

## Home contract

The home is a readable autobiography.

It should gradually reveal what the player actually spent time doing through:

- functional improvements;
- trophies;
- maps;
- recovered objects;
- crafted furniture;
- garden changes;
- Echo artefacts;
- NPC visits;
- visible restoration.

The HUD exposes an emergent home identity, but the world representation remains authoritative.

## Larkmere density contract

No second region is required while the first valley still feels thin.

Each Larkmere location should eventually have:

**place + resource + skill + person + story + Echo + secret + restoration + reason to return**

Breadth is blocked when depth is not demonstrated.

## Current implementation evidence

The depth pass now includes:

- skill-specific gathering with mastery-based yield improvements;
- persistent activity counts and daily activity memory;
- generic NPC relationship state and daily talk memory;
- authored NPC daily routines for Mara and Rowan;
- repeatable market, orchard-care, archaeology and survey activities;
- persistent world memories;
- systemic Echo prerequisites based on lived activity;
- Echo unlock flags and NPC-specific relationship consequences;
- chained River, Bellroot and Hollow Steps Echoes;
- expanded crafting recipes that become usable from the HUD;
- seasonal day progression;
- persistent home identity;
- visible world/home consequences tied to player-led milestones;
- save schema version 5 with migration coverage for the new state.

## Product gate

The next gate is not “how many systems exist?”

It is:

> **Can a player spend 45 minutes in Larkmere doing whatever they genuinely feel like doing and finish the session with a sense that their choices mattered?**

If the answer is no, build depth rather than expansion.
