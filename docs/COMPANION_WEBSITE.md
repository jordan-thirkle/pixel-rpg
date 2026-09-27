# Everdune Companion Website

Status: **concept-fidelity implementation pass — 2026-09-27**

The public-facing site in `web/index.html` now follows the approved Everdune companion-site composition: permanent left navigation rail, concept information architecture, real Hearthfall artwork, in-game HUD treatment, parchment Lore Book panel, feature strip, World/Characters/Creatures/Locations/Factions/Gallery/Updates sections, responsive behaviour, accessible semantic structure and an honest Steam CTA until the real store URL exists.

The Vercel build copies canonical game art into `web/assets/` so the deployed site does not depend on external image hosts.

The game repository remains the source of truth for lore and production art. The website must not invent canon that conflicts with `docs/GENESIS.md` or `docs/PIXEL_ART_BIBLE.md`.

This pass improves concept fidelity substantially, but it does **not** claim the current compact SVG art is the final cinematic production-art master. That remains a game-art gate, not something hidden by marketing UI.