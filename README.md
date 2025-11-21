 Automated Backup System:

Overview:

This is a **Bash-based Automated Backup System** that creates secure and verified backups of your important folders.
It compresses data, verifies integrity using checksums, and automatically deletes old backups to save disk space.
You can also simulate backups (dry run) and track every operation through detailed logs.

Features:
*  Create compressed backups (`.tar.gz`)
*  Generate & verify checksums for integrity
*  Auto-delete old backups (daily, weekly, monthly)
*  Configurable exclusions via config file
*  Detailed logging for every operation
*  Dry run mode to test without changes
*  Lock file system to prevent duplicate runs
Project Structure:
backup-system/
├── backup.sh          → Main backup script
├── backup.config      → Configuration file
├── backups/           → Folder for backups & logs
└── README.md          → Project documentation

Configuration File (`backup.config`):
BACKUP_DESTINATION=./backups
EXCLUDE_PATTERNS=".git,node_modules,.cache"
DAILY_KEEP=7
WEEKLY_KEEP=4
MONTHLY_KEEP=3
Notes:

* `BACKUP_DESTINATION`: where backups are stored
* `EXCLUDE_PATTERNS`: folders/files to ignore
* `DAILY_KEEP`, `WEEKLY_KEEP`, `MONTHLY_KEEP`: backup rotation limits

Usage Guide:

Step 1: Setup

chmod +x backup.sh
mkdir -p backups

Step 2: Create a Backup:

./backup.sh test_data

Example Output:
[2025-11-06 14:37:57] INFO: Starting backup of test_data
[2025-11-06 14:37:57] SUCCESS: Backup created: backup-2025-11-06-1437.tar.gz
[2025-11-06 14:37:58] SUCCESS: Backup verified successfully!
```

 Step 3: Dry Run (Simulation Mode)

./backup.sh --dry-run test_data

Output Example:

Would backup folder test_data
Would exclude .git, node_modules
Would delete old backup: backup-2025-10-25-1430.tar.gz

 How It Works:

1. Takes an input folder and creates a timestamped `.tar.gz` archive.
2. Generates a `SHA256` checksum file and verifies it.
3. Excludes unnecessary folders (like `.git`, `node_modules`).
4. Removes old backups based on configured limits.
5. Logs every action to `backups/backup.log`.

Retention Policy:

* Keep -7 daily backups 
* Keep -4 weekly backups 
* Keep -3 monthly backups

* Delete anything older automatically.

Example:
[2025-11-06 14:37:57] INFO: Starting backup of test_data
[2025-11-06 14:37:57] SUCCESS: Backup created successfully
[2025-11-06 14:37:58] INFO: Cleaning old backups

Error Handling:

The script handles common problems gracefully:

| Error Type       | Example Message                            |
| ---------------- | ------------------------------------------ |
| Missing folder   | `Error: Source folder not found!`          |
| Missing config   | `Error: Configuration file not found!`     |
| Low disk space   | `Error: Not enough disk space for backup!` |
| Permission issue | `Error: Cannot read folder!`               |

Testing Summary:

* Created new backups successfully
* Verified checksums after creation
* Tested dry run and exclusion patterns
* Confirmed rotation deletes older backups
* Validated error messages for edge cases

Known Limitations:

* Email notifications not yet implemented
* Incremental backups (changed files only) not supported
* Restore feature is optional and basic

Example Backup Folder:
backups/
├── backup-2025-11-06-1437.tar.gz
├── backup-2025-11-06-1437.tar.gz.sha256
└── backup.log
Conclusion:

This project demonstrates how to **automate file backups with Bash scripting**.
It’s simple, reliable, and configurable — a great DevOps exercise for real-world automation tasks.


 Author:Dharsha Kunduru
 Date:07/11/2025
 Subject: DevOps(Bash Scripting)

 



