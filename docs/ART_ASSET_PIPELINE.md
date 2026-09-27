# ART ASSET PIPELINE

Reference → generation → cleanup → pixel validation → art-direction review → manifest → runtime integration.

Website and game must share the same canonical visual language.

Concept sheets are references, not automatically production sprite sheets.

Production assets must be converted to exact canvas sizes, pivots, transparent backgrounds, consistent palette, deterministic naming and animation-ready frames.


## Production Art Pass — 2026-09-27

The first runtime art-quality pass is now integrated without replacing the gameplay contracts.

- enriched terrain atlas: grass, water, path, bridge, flower meadow and darker meadow variants
- enriched prop atlas: trees, homes, well, market, NPCs, Echo stone, fishing spot, stone and flowers
- layered player sheets retained as swappable production-facing assets
- crisp-edge rendering remains mandatory
- environmental dressing is authored in world composition rather than generated debug drawing
- interaction feedback now has lightweight spark/echo VFX
- weather/day-night remains presentation-layer state
- UI panels/buttons now use the Everdune material language rather than stock panel presentation

The next art pass should move from atlas-level polish to hero assets: canonical character sprites, directional animation, equipment layers, environment transition tiles, foreground silhouettes, water/foliage animation, authored VFX and final audio.
