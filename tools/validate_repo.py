from __future__ import annotations
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "README.md",
    "docs/SYSTEM_MAP.md",
    "docs/STACK_LOCK.md",
    "docs/PRODUCTION_RULES.md",
    "docs/PLACEHOLDER_REGISTRY.md",
    "docs/EVEDUNE_VERTICAL_SLICE_QUALITY_GATE.md",
    "game/project.godot",
    "game/scripts/main.gd",
    "game/scripts/game_state.gd",
    "game/scripts/content_registry.gd",
    "game/scripts/data/echo_data.gd",
    "game/scripts/data/npc_data.gd",
    "game/scripts/data/location_data.gd",
]

def main() -> None:
    missing = [p for p in REQUIRED if not (ROOT / p).is_file()]
    if missing:
        raise SystemExit("Missing canonical files:\n" + "\n".join(missing))

    manifest = json.loads((ROOT / "assets/ASSET_MANIFEST.json").read_text(encoding="utf-8"))
    runtime = [x["path"] for x in manifest.get("runtimeAssets", [])]
    missing_assets = [p for p in runtime if not (ROOT / p).is_file()]
    if missing_assets:
        raise SystemExit("Manifest runtime assets missing:\n" + "\n".join(missing_assets))

    for forbidden in ["game/scripts/world.gd"]:
        if (ROOT / forbidden).exists():
            raise SystemExit(f"Obsolete canonical path still exists: {forbidden}")

    print("Repository validation passed.")

if __name__ == "__main__":
    main()
