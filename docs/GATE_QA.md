# Everdune Gate QA — Web Runtime + Visual Reference

## Gate
**Godot Web export → Vercel /game/ → /play/ → playable runtime → reference visual QA → content/art continuation**

## Architecture under test
- Godot 4.7.2-stable remains the game runtime.
- GDScript remains the gameplay language.
- Vercel serves the website and generated Godot Web export.
- /game/ is generated during the Vercel build; exported binaries are not manually copied into the repository.
- /play/ is the dedicated browser-play shell.
- The homepage hero can instantiate the same real Godot runtime inside the concept-matched game frame.
- The website is presentation/discovery; game state remains inside Godot.

Godot supports command-line export and custom Web HTML shells; this project uses the documented command-line export path and the standard Web shell for the first Vercel gate.

## Automated checks
- Repository foundation validation.
- Godot headless editor/project parse.
- Godot Web export.
- Vercel website integrity.
- Vercel build generates web/game/index.html.
- Vercel build generates the Godot JavaScript/PCK/WASM payload.
- Homepage references the real /game/index.html runtime.
- /play/ references the real /game/index.html runtime.

## Manual/AI visual QA checklist
### Composition
- [ ] Left Everdune identity rail remains visually dominant.
- [ ] Top navigation stays restrained.
- [ ] Central gameplay frame is the largest visual object.
- [ ] Parchment lore book anchors the right side.
- [ ] Four feature panels form the first content row.
- [ ] Steam CTA remains obvious without overpowering the game.

### Art language
- [ ] Cinematic pixel-fantasy.
- [ ] Warm lantern light against deep navy/forest shadows.
- [ ] Teal/blue water and readable shoreline.
- [ ] Dense vegetation and authored prop clusters.
- [ ] Strong character silhouettes.
- [ ] No generic neon/AI-dashboard styling.
- [ ] UI materials remain wood/parchment/iron/brass.

### Runtime UX
- [ ] Character creation works.
- [ ] Movement works.
- [ ] Interaction works.
- [ ] Gather/fish/craft works.
- [ ] Echo progression works.
- [ ] Save/load works.
- [ ] Combat branch works.
- [ ] Settings persist.
- [ ] Browser fullscreen path works.
- [ ] Mobile/small viewport fails gracefully rather than pretending to be a touch-first game.

### Regression rule
A visual improvement must not bypass the executable content spine:

Create Wayfarer → Hearthfall → Mara/Rowan → gather → fish → Old Road Echo → Mara → Glass Orchard → craft Hearth Lamp → Sleeping Gate → optional combat trial → return home.

## Second-eyes review principle
Every gate is reviewed from two perspectives:

1. **Player eye:** Is the experience immediately understandable, attractive, responsive and coherent?
2. **Production eye:** Is the implementation real, testable, replaceable, data-driven and still aligned with the locked architecture?

A passing gate requires both. A pretty mockup that is not playable is not a pass; a technically functional build that visually diverges from the approved Everdune language is also not a pass.