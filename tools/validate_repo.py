from __future__ import annotations
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "README.md","docs/SYSTEM_MAP.md","docs/STACK_LOCK.md","docs/PRODUCTION_RULES.md",
    "docs/PLACEHOLDER_REGISTRY.md","docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md",
    "game/project.godot","game/scripts/main.gd","game/scripts/game_state.gd",
    "game/scripts/content_registry.gd","game/scripts/data/echo_data.gd",
    "game/scripts/data/npc_data.gd","game/scripts/data/location_data.gd",
    "game/scripts/systems/freeplay_system.gd","game/scripts/systems/crafting_system.gd",
    "game/scripts/systems/echo_system.gd","game/scripts/systems/npc_system.gd"
]

HERO_LAYERS = [
    "game/assets/player_body.svg","game/assets/player_hair.svg","game/assets/player_coat.svg",
    "game/assets/hero_face.svg","game/assets/hero_shirt.svg","game/assets/hero_trousers.svg",
    "game/assets/hero_boots.svg","game/assets/hero_accessory.svg","game/assets/hero_back.svg",
]

AUDIO_CUES = [
    "gather","fish_cast","fish_bite","fish_catch","fish_miss","echo","craft","ui",
    "level","swing","hit","defeat","gate_open","home",
]

def main() -> None:
    missing = [p for p in REQUIRED if not (ROOT / p).is_file()]
    if missing:
        raise SystemExit("Missing canonical files:\n" + "\n".join(missing))

    manifest = json.loads((ROOT / "assets/ASSET_MANIFEST.json").read_text(encoding="utf-8"))
    listed = {x["path"] for x in manifest.get("runtimeAssets", [])}
    actual = {
        str(p.relative_to(ROOT)).replace("\\","/")
        for p in (ROOT/"game/assets").glob("*")
        if p.is_file() and p.suffix.lower() in {".svg",".png",".webp",".ogg",".wav"}
    }
    if actual != listed:
        raise SystemExit(
            "Runtime asset manifest drift:\n"
            "missing from manifest: %s\nunexpected in manifest: %s"
            % (sorted(actual-listed), sorted(listed-actual))
        )

    for entry in manifest.get("dataResources", []):
        if not (ROOT / entry["path"]).is_file():
            raise SystemExit("Manifest data resource missing: " + entry["path"])

    for forbidden in ["game/scripts/world.gd","everdune_pixel_rpg_mvp.html"]:
        if (ROOT / forbidden).exists():
            raise SystemExit(f"Obsolete prototype path still exists: {forbidden}")

    for relative in HERO_LAYERS:
        source = (ROOT / relative).read_text(encoding="utf-8")
        if 'shape-rendering="crispEdges"' not in source:
            raise SystemExit(f"Hero layer is not crisp-edge pixel art: {relative}")
        if 'width="128"' not in source or 'height="128"' not in source:
            raise SystemExit(f"Hero layer has unexpected sheet dimensions: {relative}")
        if source.count('<g transform="translate(') != 16:
            raise SystemExit(f"Hero layer must contain exactly 16 animation frames: {relative}")

    freeplay = (ROOT / "game/scripts/systems/freeplay_system.gd").read_text(encoding="utf-8")
    for activity in ["market", "orchard_care", "archaeology", "survey"]:
        if f'"{activity}":' not in freeplay and f'"{activity}"' not in freeplay:
            raise SystemExit(f"Depth activity missing from FreeplaySystem: {activity}")

    crafting = (ROOT / "game/scripts/systems/crafting_system.gd").read_text(encoding="utf-8")
    for recipe in ["hearth_lamp", "fisher_rack", "herb_shelf", "archive_case"]:
        if f'"{recipe}":' not in crafting:
            raise SystemExit(f"Crafting recipe missing: {recipe}")

    state = (ROOT / "game/scripts/game_state.gd").read_text(encoding="utf-8")
    for token in ["activity_last_day", "relationships", "home_identity", "_season_for_day"]:
        if token not in state:
            raise SystemExit(f"Systemic progression state contract missing: {token}")

    save = (ROOT / "game/scripts/save_system.gd").read_text(encoding="utf-8")
    if "const CURRENT_VERSION := 5" not in save:
        raise SystemExit("Save schema is not at depth-pass version 5.")
    for token in ["activity_last_day", "relationships"]:
        if token not in save:
            raise SystemExit(f"Save migration missing depth field: {token}")

    echo_system = (ROOT / "game/scripts/systems/echo_system.gd").read_text(encoding="utf-8")
    for token in ["prerequisite_activities", "unlock_flags", "relationship_npc_id"]:
        if token not in echo_system:
            raise SystemExit(f"Systemic Echo contract missing: {token}")

    interaction = (ROOT / "game/scripts/systems/interaction_system.gd").read_text(encoding="utf-8")
    if '"prerequisite_flags": location.prerequisite_flags' not in interaction:
        raise SystemExit("Location prerequisite flags are not carried into interaction routing.")

    registry_runtime = (ROOT / "game/scripts/content_registry.gd").read_text(encoding="utf-8")
    for resource_id in ["river_song.tres", "bellroot_ledger.tres", "hollow_steps_echo.tres", "market.tres", "orchard_care.tres", "archaeology.tres", "survey.tres"]:
        if resource_id not in registry_runtime:
            raise SystemExit(f"Depth resource not registered: {resource_id}")

    for required_echo in [
        "game/data/echoes/river_song.tres",
        "game/data/echoes/bellroot_ledger.tres",
        "game/data/echoes/hollow_steps_echo.tres",
    ]:
        text = (ROOT / required_echo).read_text(encoding="utf-8")
        for token in ["prerequisite_activities", "unlock_flags", "world_memory_id"]:
            if token not in text:
                raise SystemExit(f"Echo chain resource is incomplete: {required_echo} ({token})")

    audio = (ROOT / "game/scripts/audio.gd").read_text(encoding="utf-8")
    for cue in AUDIO_CUES:
        if f'"{cue}":' not in audio:
            raise SystemExit(f"Final audio motif missing: {cue}")
    if "func _ambient_chord" not in audio:
        raise SystemExit("Final audio score is missing the authored ambient layer.")

    registry = (ROOT / "docs/PLACEHOLDER_REGISTRY.md").read_text(encoding="utf-8")
    for phrase in [
        "Hero body/hair/coat + production layer set | PASSED",
        "Hearthfall vertical-slice score | PASSED",
    ]:
        if phrase not in registry:
            raise SystemExit("Production gate is not recorded as passed: " + phrase)

    print("Repository + production asset + depth validation passed.")

if __name__ == "__main__":
    main()
