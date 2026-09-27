from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "README.md","docs/SYSTEM_MAP.md","docs/STACK_LOCK.md","docs/PRODUCTION_RULES.md",
    "docs/PLACEHOLDER_REGISTRY.md","docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md",
    "game/project.godot","game/scripts/main.gd","game/scripts/game_state.gd",
    "game/scripts/content_registry.gd","game/scripts/data/echo_data.gd",
    "game/scripts/data/npc_data.gd","game/scripts/data/location_data.gd"
]

def main() -> None:
    missing = [p for p in REQUIRED if not (ROOT / p).is_file()]
    if missing:
        raise SystemExit("Missing canonical files:\n" + "\n".join(missing))
    manifest = json.loads((ROOT / "assets/ASSET_MANIFEST.json").read_text(encoding="utf-8"))
    listed = {x["path"] for x in manifest.get("runtimeAssets", [])}
    actual = {str(p.relative_to(ROOT)).replace("\\","/") for p in (ROOT/"game/assets").glob("*") if p.is_file() and p.suffix.lower() in {".svg",".png",".webp",".ogg",".wav"}}
    if actual != listed:
        raise SystemExit("Runtime asset manifest drift:\nmissing from manifest: %s\nunexpected in manifest: %s" % (sorted(actual-listed), sorted(listed-actual)))
    for entry in manifest.get("dataResources", []):
        if not (ROOT / entry["path"]).is_file():
            raise SystemExit("Manifest data resource missing: " + entry["path"])
    for forbidden in ["game/scripts/world.gd","everdune_pixel_rpg_mvp.html"]:
        if (ROOT / forbidden).exists():
            raise SystemExit(f"Obsolete prototype path still exists: {forbidden}")
    print("Repository validation passed.")

if __name__ == "__main__":
    main()
