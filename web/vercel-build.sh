#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WEB_DIR="$ROOT/web"; GAME_DIR="$ROOT/game"; GODOT_VERSION="4.7.2-stable"
CACHE_DIR="${TMPDIR:-/tmp}/everdune-godot-${GODOT_VERSION}"
GODOT_ZIP="$CACHE_DIR/Godot_v4.7.2-stable_linux.x86_64.zip"; TEMPLATES_TPZ="$CACHE_DIR/Godot_v4.7.2-stable_export_templates.tpz"
TEMPLATE_DIR="${HOME}/.local/share/godot/export_templates/4.7.2.stable"; OUT_DIR="$WEB_DIR/game"
mkdir -p "$CACHE_DIR" "$OUT_DIR" "$TEMPLATE_DIR"
if [ ! -x "$CACHE_DIR/Godot_v4.7.2-stable_linux.x86_64" ]; then
  if [ ! -f "$GODOT_ZIP" ]; then curl -fsSL --retry 3 --retry-all-errors "https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip" -o "$GODOT_ZIP"; fi
  rm -rf "$CACHE_DIR/editor"; mkdir -p "$CACHE_DIR/editor"; unzip -q -o "$GODOT_ZIP" -d "$CACHE_DIR/editor"
  BIN="$(find "$CACHE_DIR/editor" -type f -name 'Godot_v4.7.2-stable_linux.x86_64' -perm -111 | head -n 1)"; test -n "$BIN"
  cp "$BIN" "$CACHE_DIR/Godot_v4.7.2-stable_linux.x86_64"; chmod +x "$CACHE_DIR/Godot_v4.7.2-stable_linux.x86_64"
fi
if [ ! -f "$TEMPLATE_DIR/web_release.zip" ]; then
  if [ ! -f "$TEMPLATES_TPZ" ]; then curl -fsSL --retry 3 --retry-all-errors "https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_export_templates.tpz" -o "$TEMPLATES_TPZ"; fi
  rm -rf "$CACHE_DIR/templates"; mkdir -p "$CACHE_DIR/templates"; unzip -q -o "$TEMPLATES_TPZ" -d "$CACHE_DIR/templates"
  test -d "$CACHE_DIR/templates/templates"; cp -R "$CACHE_DIR/templates/templates/." "$TEMPLATE_DIR/"
fi
rm -rf "$OUT_DIR"; mkdir -p "$OUT_DIR"; GODOT="$CACHE_DIR/Godot_v4.7.2-stable_linux.x86_64"
"$GODOT" --headless --path "$GAME_DIR" --editor --quit
"$GODOT" --headless --path "$GAME_DIR" --export-release "Web" "$OUT_DIR/index.html"
test -s "$OUT_DIR/index.html"; test -s "$OUT_DIR/index.js"; test -s "$OUT_DIR/index.pck" || test -s "$OUT_DIR/index.zip" || true
ART_DIR="$WEB_DIR/assets"; rm -rf "$ART_DIR"; mkdir -p "$ART_DIR"
for asset in hearthfall_scene.svg environment_detail.svg terrain_atlas.svg props.svg player_body.svg npc_ornaments.svg; do cp "$GAME_DIR/assets/$asset" "$ART_DIR/$asset"; done
cat > "$OUT_DIR/build-info.json" <<EOF
{"game":"Everdune","codename":"The World Remembers","engine":"$GODOT_VERSION","build":"vercel","commit":"${VERCEL_GIT_COMMIT_SHA:-local}"}
EOF
echo "== Export complete =="; find "$OUT_DIR" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort
echo "== Companion art =="; find "$ART_DIR" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort