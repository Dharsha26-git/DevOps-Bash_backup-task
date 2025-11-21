                                            Automated Backup System

1. Overview:

This is a Automated Backup System that creates secure and verified backups of your important folders to store.
It compresses data, verifies integrity using checksums, and automatically deletes old backups to save disk space.


2. Features:
   
->  Create compressed backups likewise tar.gz zip file.

->  Generate & verify checksums for integrity

->  Auto-delete old backups like daily,weekly,monthly.

->  Configurable exclusions via config file.

->  Detailed logging for every operation.

->  Dry run mode to test without changes.

->  Lock file system to prevent duplicate runs.

  
3. Project Structure:

backup-system/

├── backup.sh    

├── backup.config

|── README.md

|── backups/  
  ├── backup-2025-11-06-1437.tar.gz
  
  ├── backup-2025-11-06-1437.tar.gz.sha256
  
  └── backup.log

         

4. Backup.config File:
   
BACKUP_DESTINATION=./backups

EXCLUDE_PATTERNS=".git,node_modules,.cache"

DAILY_KEEP=7

WEEKLY_KEEP=4

MONTHLY_KEEP=3



5. How to run:

Step 1: Setup

chmod +x backup.sh

mkdir -p backups

Step 2: Create a Backup:

 ./backup.sh test_data


6. How it works:

-> Takes an input folder and creates a timestamped ".tar.gz" archive.
   
-> Generates a "SHA256" checksum file and verifies it.

-> Excludes unnecessary folders.

-> Removes old backups based on configured limits.

-> Logs every action to "backups/backup.log".



7. Error Handling:
   ---------------

  The script handles common problems gracefully:


  -> Missing folder   : Error: Source folder not found
  
 -> Missing config   : Error: Configuration file not found
  
  -> Low disk space   : Error: Not enough disk space for backup
  
  -> Permission issue : Error: Cannot read folder       


8. Sample Output(backup.log):

[2025-11-06 14:37:57] INFO: Starting backup of test_data

[2025-11-06 14:37:57] SUCCESS: Backup created: backup-2025-11-06-1437.tar.gz

[2025-11-06 14:37:57] INFO: Checksum file created: backup-2025-11-06-1437.tar.gz.sha256

[2025-11-06 14:37:57] SUCCESS: Backup archive integrity verified!

[2025-11-06 14:37:57] INFO: Cleaning old backups...

[2025-11-06 14:37:58] INFO: No old backups to delete.

[2025-11-06 14:37:58] SUCCESS: Backup process completed successfully!

[2025-11-06 14:41:54] INFO: Starting backup of test_data

[2025-11-06 14:41:55] SUCCESS: Backup created: backup-2025-11-06-1441.tar.gz

[2025-11-06 14:41:55] INFO: Checksum file created: backup-2025-11-06-1441.tar.gz.sha256

[2025-11-06 14:41:55] SUCCESS: Backup archive integrity verified!

[2025-11-06 14:41:55] INFO: Cleaning old backups...

[2025-11-06 14:41:55] INFO: No old backups to delete.

[2025-11-06 14:41:55] SUCCESS: Backup process completed successfully!


Conclusion:

This project demonstrates how to "automate file backups with Bash scripting".



 Author:Dharsha Kunduru
 
 Date:07/11/2025
 
 Subject: DevOps(Bash Scripting)

 







