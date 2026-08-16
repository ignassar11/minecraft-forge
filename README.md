# minecraft-forge

Forge server config for our modded Minecraft world (MC 26.2, Forge 65.1.1). This repo tracks server config and the mod list (via packwiz) — not the world save, logs, or mod jars themselves.

## Server setup

1. Clone the repo
2. Download the Forge server installer for `26.2-65.1.1` from [files.minecraftforge.net](https://files.minecraftforge.net/net/minecraftforge/forge/index_26.2.html) and run:
   ```bash
   java -jar forge-26.2-65.1.1-installer.jar --installServer
   ```
3. Install mods (see below)
4. Start the server:
   ```bash
   ./run.sh nogui
   ```

## Installing mods

Mods aren't stored in git — they're fetched from the pack manifest using `packwiz-installer-bootstrap.jar`, which is included in this repo.

```bash
java -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ignassar11/minecraft-forge/main/pack.toml
```

This downloads everything into `mods/`, matching the current pack exactly. Run it again anytime the pack updates.

**Client players**: copy `packwiz-installer-bootstrap.jar` from this repo into your `.minecraft` folder (or reference it by full path), then run the same command with `-s client` to skip any server-only mods:

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
