# Everdune Boot & First-Run Gate

## Non-negotiable

The first impression is part of the product. Everdune must never present a fake loading percentage, fake ready state, CSS mock game, or placeholder artwork as the playable game.

## Browser startup

1. Vercel serves the Godot Web export.
2. The custom Godot HTML shell reports real engine/PCK byte progress through Godot's onProgress(current,total) callback.
3. If the browser cannot calculate a total, the UI reports bytes loaded and does not invent a percentage.
4. Startup errors are surfaced rather than silently leaving a blank canvas.
5. Once the engine is ready, the Godot boot scene takes over.

## Godot startup

1. Boot scene uses ResourceLoader.load_threaded_request() for the actual main scene.
2. Progress is read from ResourceLoader.load_threaded_get_status().
3. The percentage shown in the Godot boot screen is the loader's actual resource progress.
4. When the resource is loaded, the real main scene is instantiated.
5. There is no artificial wait inserted solely to make a progress bar look good.

## First-run product flow

**Real loading → Everdune title menu → New Journey / Continue → Wayfarer creation → Hearthfall gameplay.**

Continue is only enabled when a real local save exists.

## Visual gate

The playable game must use authored game assets and the locked Everdune visual language:

- cinematic pixel fantasy
- dense vegetation and environmental dressing
- warm lantern/fire light
- deep forest/navy shadows
- teal river/water
- readable characters and silhouettes
- wood/parchment/iron/brass UI

The public website must embed the real Godot runtime. CSS scenery must not be presented as gameplay.

## QA

A release candidate is not considered playable until:

- Web export succeeds in CI.
- Boot scene succeeds in headless validation.
- /game/ serves the exported runtime.
- /play/ serves the same runtime.
- The first-run flow reaches the title menu.
- New Journey reaches Wayfarer creation.
- Creation reaches Hearthfall.
- WASD/arrows move the real player.
- E interaction works.
- Save/Continue works.
- The reference visual language is visible in the actual runtime, not only on the website.
