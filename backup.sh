#!/bin/bash
CONFIG_FILE="./backup.config"
# shellcheck source=./backup.config
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found!"
    exit 1
fi
DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    shift
fi
SOURCE_DIR=$1
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source folder not found!"
    exit 1
fi
# ----------- Variables -----------
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_NAME="backup-$TIMESTAMP.tar.gz"
CHECKSUM_FILE="$BACKUP_NAME.sha256"
LOG_FILE="$BACKUP_DESTINATION/backup.log"
LOCK_FILE="/tmp/backup.lock"

mkdir -p "$BACKUP_DESTINATION"
touch "$LOG_FILE"
# ----------- Logging Function -----------
log() {
    local message="$1"
    printf '[%s] %s\n' "$(date +"%Y-%m-%d %H:%M:%S")" "$message" | tee -a "$LOG_FILE"
}
# ----------- Prevent Multiple Runs -----------
if [ -f "$LOCK_FILE" ]; then
    log "Error: Another backup is running! ($LOCK_FILE exists)"
    exit 1
fi
echo "$$" > "$LOCK_FILE"
# ----------- Cleanup on Exit -----------
cleanup() {
    rm -f "$LOCK_FILE"
}
trap cleanup EXIT
# ----------- Exclude Patterns -----------
IFS=',' read -r -a EXCLUDES <<< "$EXCLUDE_PATTERNS"
EXCLUDE_ARGS=()
for pattern in "${EXCLUDES[@]}"; do
    
    if [ -n "$pattern" ]; then
        EXCLUDE_ARGS+=( "--exclude=$pattern" )
    fi
done
# ----------- Create Backup -----------
log "INFO: Starting backup of $SOURCE_DIR"
if $DRY_RUN; then
    log "DRY-RUN: Would create archive $BACKUP_NAME"
else   
    tar -czf "$BACKUP_DESTINATION/$BACKUP_NAME" "${EXCLUDE_ARGS[@]}" "$SOURCE_DIR"
    if [ "$?" -ne 0 ]; then
        log "ERROR: Failed to create backup archive!"
        exit 1
    fi
fi
log "SUCCESS: Backup created: $BACKUP_NAME"
# ----------- Generate Checksum -----------
if $DRY_RUN; then
    log "DRY-RUN: Would generate checksum file $CHECKSUM_FILE"
else
    (
        cd "$BACKUP_DESTINATION" || exit 1
        sha256sum "$BACKUP_NAME" > "$CHECKSUM_FILE"
    )
    log "INFO: Checksum file created: $CHECKSUM_FILE"
fi
# ----------- Verify Backup -----------
if ! $DRY_RUN; then
    (
        cd "$BACKUP_DESTINATION" || exit 1
        if sha256sum -c "$CHECKSUM_FILE" >/dev/null 2>&1; then
            log "SUCCESS: Checksum verification passed!"
        else
            log "ERROR: Checksum verification failed!"
            exit 1
        fi
    )
    if tar -tzf "$BACKUP_DESTINATION/$BACKUP_NAME" >/dev/null 2>&1; then
        log "SUCCESS: Backup archive integrity verified!"
    else
        log "ERROR: Backup archive is corrupted!"
        exit 1
    fi
fi
# ----------- Delete Old Backups -----------
log "INFO: Cleaning old backups..."
mapfile -t BACKUPS < <(ls -1t "$BACKUP_DESTINATION"/backup-*.tar.gz 2>/dev/null || true)
COUNT=${#BACKUPS[@]}
if [ "$COUNT" -gt "$DAILY_KEEP" ]; then
    for ((i=DAILY_KEEP; i<COUNT; i++)); do
        OLD_BACKUP=${BACKUPS[$i]}
        OLD_CHECKSUM="${OLD_BACKUP}.sha256"
        if $DRY_RUN; then
            log "DRY-RUN: Would delete old backup $OLD_BACKUP"
        else
            rm -f "$OLD_BACKUP" "$OLD_CHECKSUM"
            log "INFO: Deleted old backup: $(basename "$OLD_BACKUP")"
        fi
    done
else
    log "INFO: No old backups to delete."
fi
log "SUCCESS: Backup process completed successfully!"
