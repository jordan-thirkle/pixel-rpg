# First-session production pass

## Scope
Boot → Title → Creator → Hearthfall → Mara → movement → gathering → fishing → Echo → crafting → Sleeping Gate → combat → home.

## Resolved in this pass
- Authored Hearthfall and title presentation replaces the visible prototype backdrop.
- Runtime Wayfarer, Mara, Rowan and Mossling sheets now use distinct authored silhouettes.
- Player camera uses Godot's built-in 2D smoothing capability while preserving the fixed Hearthfall bounds.
- Fishing now has a reaction-quality outcome rather than a binary timed interaction.
- Crafting now has three meaningful slice recipes: Hearth Lamp, Wayfarer Rod, Echo Lantern.
- Echo Lantern persists as home evidence.
- Combat now requires directional intent and has recovery timing plus an attack arc.
- TileMapLayer remains authoritative for collision/topology; art remains presentation.

## Research basis
Godot 4.7 documents TileMapLayer as the current tile-map direction, Camera2D as supporting smoothing/drag, SVG as an imported 2D texture format, and 2D Sprite/Polygon/Line rendering plus lighting/VFX capabilities. GDQuest's open-source Godot OpenRPG demonstrates separation of combat, inventory, progression, maps, dialogue and UI as a reusable architecture pattern.

- https://docs.godotengine.org/en/4.7/
- https://docs.godotengine.org/en/4.7/about/list_of_features.html
- https://docs.godotengine.org/en/4.7/classes/class_resourceimportersvg.html
- https://github.com/gdquest-demos/godot-open-rpg
