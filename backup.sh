#!/bin/bash
BACKUP_DIR="$(pwd)/backups"
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/world-backup-$(date +%Y%m%d-%H%M).tar.gz" world/
echo "Backup saved to $BACKUP_DIR/world-backup-$(date +%Y%m%d-%H%M).tar.gz"
