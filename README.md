# minecraft-forge

Forge server config for modded Minecraft world. This repo tracks server config and the mod list (via packwiz) — not the world save, logs, mod jars, or the installer jar itself.

## 1. Clone the repo

```bash
git clone https://github.com/ignassar11/minecraft-forge.git
cd minecraft-forge
```

## 2. Install the Forge server

Download the installer for `26.2-65.1.1` (or any other version according to branching) from [files.minecraftforge.net](https://files.minecraftforge.net/net/minecraftforge/forge/index_26.2.html), then:

```bash
java -jar forge-26.2-65.1.1-installer.jar --installServer
```

## 3. Install mods (server)

Use the included script — it grabs the packwiz bootstrap installer if needed and installs mods from the current branch's pack:

```bash
chmod +x install-mods.sh
./install-mods.sh server <branch>
```

Windows:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\install-mods.ps1 server <branch>
```

Downloads everything into `mods/`, matching the current pack. Re-run anytime the pack updates.

## 4. Start the server

```bash
./run.sh nogui
```

## Installing mods (client players)

Same script, `client` instead of `server` — installs into `.minecraft` and skips server-only mods:

```bash
./install-mods.sh client <branch>
```

Windows:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\install-mods.ps1 client <branch>
```

## Adding mods (maintainer only)

Requires [packwiz](https://packwiz.infra.link/) installed locally.

```bash
packwiz mr install <mod-slug>   # from Modrinth
packwiz cf install <mod-slug>   # from CurseForge
```

Commit and push `mods/`, `index.toml`, and `pack.toml` afterward.

## Switching mod loader or version

Forge, Fabric, and NeoForge can't run the same mods and can't mix on one server. Each gets its own branch. Shared config (`server.properties`, `whitelist.json`, `ops.json`, `banned-*.json`) lives on `master`; loader-specific files (`pack.toml`, `mods/`, run scripts) live per branch.

```bash
git checkout -b fabric-26.2
```

Point the install scripts at the branch you want:

```bash
./install-mods.sh client fabric-26.2
```

A world built on one loader's mods won't load cleanly on another — start fresh when switching unless the current world is still unmodded.

## World backups

World saves aren't in git. `backups/` is gitignored and lives inside this project folder.

```bash
tar -czf backups/world-backup-$(date +%Y%m%d-%H%M).tar.gz world/
```

## Restoring a backup

```bash
rm -rf world/
tar -xzf backups/world-backup-<timestamp>.tar.gz
```

STAY ALERT! THIS WILL REMOVE THE CURRENT WORLD AND INITIALIZE THE BACKUP!