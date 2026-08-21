#!/bin/bash
# Universal packwiz installer/sync for server or client.
# made by IgnasSar
#
# Usage:
#   ./install-mods.sh server <branch>   # installs into current directory
#   ./install-mods.sh client <branch>   # installs into ~/.minecraft
#
# Example:
#   ./install-mods.sh client forge-26.2

set -e

REPO="ignassar11/minecraft-forge"
SIDE="$1"
BRANCH="$2"

if [ -z "$SIDE" ] || [ -z "$BRANCH" ]; then
  echo "Usage: ./install-mods.sh <server|client> <branch>"
  echo "Example: ./install-mods.sh client forge-26.2"
  exit 1
fi

if [ "$SIDE" != "server" ] && [ "$SIDE" != "client" ]; then
  echo "Error: side must be 'server' or 'client', got '$SIDE'"
  exit 1
fi

if [ "$SIDE" == "server" ]; then
  TARGET_DIR="$(pwd)"
else
  TARGET_DIR="$HOME/.minecraft"
fi

PACK_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/pack.toml"
BOOTSTRAP_JAR="$TARGET_DIR/packwiz-installer-bootstrap.jar"

echo "Side: $SIDE"
echo "Branch: $BRANCH"
echo "Target: $TARGET_DIR"

echo "Checking pack.toml exists on branch '$BRANCH'..."
if ! curl -sfL "$PACK_URL" > /dev/null; then
  echo "Error: no pack.toml found on branch '$BRANCH'. Check the branch name."
  exit 1
fi

if [ -f "$BOOTSTRAP_JAR" ]; then
  echo "Bootstrap installer already present, skipping download."
else
  echo "Downloading packwiz-installer-bootstrap.jar..."
  curl -L -o "$BOOTSTRAP_JAR" https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar
fi

if [ "$SIDE" == "client" ]; then
  echo "Clearing old mods and install state..."
  rm -rf "$TARGET_DIR/mods"
  rm -f "$TARGET_DIR/packwiz.json"
else
  echo "Server mode: leaving mods/ in place (this folder is also the packwiz source)."
fi

echo "Installing mods ($SIDE)..."
cd "$TARGET_DIR"
java -jar "$BOOTSTRAP_JAR" -s "$SIDE" "$PACK_URL"

echo "Done. Mods for branch '$BRANCH' ($SIDE) are in $TARGET_DIR/mods"
