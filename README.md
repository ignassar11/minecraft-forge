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

## 3. Get the packwiz bootstrap installer

Not included in this repo — download it:

```bash
curl -L -o packwiz-installer-bootstrap.jar https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar
```

## 4. Install mods (server)

```bash
java -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ignassar11/minecraft-forge/main/pack.toml
```

Downloads everything into `mods/`, matching the current pack. Re-run anytime the pack updates.

## 5. Start the server

```bash
./run.sh nogui
```

## Installing mods (client players)

Download the bootstrap jar the same way as step 3, then run from inside `.minecraft`:

```bash
cd ~/.minecraft   # Windows: cd %appdata%\.minecraft
java -jar packwiz-installer-bootstrap.jar -s client https://raw.githubusercontent.com/ignassar11/minecraft-forge/main/pack.toml
```

## Adding mods (maintainer only)

Requires [packwiz](https://packwiz.infra.link/) installed locally.

```bash
packwiz mr install <mod-slug>   # from Modrinth
packwiz cf install <mod-slug>   # from CurseForge
```

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