# EVERDUNE OPEN-SOURCE / SOLVED-PROBLEM STACK

Updated: September 2026.

The rule is reuse proven solutions where they are materially better than bespoke code; keep our simulation/state layer proprietary and data-driven.

## Engine/runtime
- Godot 4.7.2-stable is pinned for the production game.
- GDScript is the primary gameplay language.
- Compatibility renderer is retained because the first target is pixel-first 2D and the browser demo must work.
- Web export is a development/review target, not the Steam runtime.

## High-value open-source references / candidates

| Area | Project / source | Decision |
|---|---|---|
| Pixel shaders | GDQuest godot-shaders | Reference/adopt individual MIT-compatible shaders where useful |
| Pixel water | taillight-games/godot-4-pixelated-water-shader | Evaluate for river foam/waves; do not replace deterministic water until benchmarked |
| Pixel dynamic lighting | SalvaPixel/PixelLight | Evaluate for pixel-quantized light/shadows; current light remains fallback |
| Weather | gregrylivingston/Godot4---Weather-System-2D | Strong candidate; pure GDScript/shaders, Godot 4.7 tested, seeded presets and low-graphics path |
| Game feel | neohex-interactive/sparkelite | Candidate for camera shake, hit-stop, flash, scale punch, audio pooling |
| Dialogue | nathanhoad/godot_dialogue_manager | Candidate when branching dialogue/content volume exceeds the current lightweight system |
| Dialogue voice | blazQ/dialogot | Candidate for optional character voice/animalese layer |
| Camera | artom-studios/ProCam2D | Candidate if camera requirements outgrow native Camera2D |
| Inventory | expressobits/inventory-system | Candidate for data/resource-driven inventory if custom inventory becomes limiting |
| Steam | GodotSteam | Historical integration reference only: upstream repository was archived September 4, 2026, so validate any integration before adoption |
| Web | Godot 4.7 Web export | Supported export path; browser demo is CI-built and Pages-deployed |

## What we should NOT outsource
- Everdune simulation/state.
- Quest progression rules.
- Save schema and migrations.
- World-memory / Echo logic.
- Art direction and asset provenance.
- Economy balance.
- Player identity and character customization.
- AI content validation rules.

## Adoption rule
1. Benchmark candidate against the current implementation.
2. Check license and Godot 4.7.2 compatibility.
3. Integrate behind a replaceable boundary.
4. Keep a fallback path.
5. Add a regression test.
6. Do not add a dependency merely because it exists.

## Current asset-fidelity bottleneck

The largest remaining quality gap is authored production art: hero sprites, terrain transitions, shoreline/cliff sets, props, NPC portraits/animations, equipment silhouettes, VFX atlases, and environment-specific composition. Replacing these with more code would be the wrong optimization.
