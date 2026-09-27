# Everdune Web

The public Everdune site is a fixed, cinematic game-world interface rather than a conventional long marketing page.

The approved concept composition is the visual source of truth:
- dark navy / ink background and antique parchment surfaces
- left Everdune identity rail
- restrained top navigation
- central playable-game frame
- right lore book panel and tab rail
- four feature cards below the game
- Steam CTA

`/play/` is the dedicated browser-play route. The deployed Godot Web export is mounted at `/game/`.

The website and game stay separate: HTML/CSS provides the presentation shell while the playable runtime remains Godot. Godot 4.7 supports custom HTML shells for click-to-play/fullscreen and custom loading UI, and Web export can be automated from the command line.