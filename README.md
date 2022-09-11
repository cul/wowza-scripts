# CUL Wowza Scripts

Various scripts for administering a Wowza Streaming Engine application.

## Current scripts:
- bash/set-allowed-ips.sh

  A bash script for updating the IP whitelist for a given wowza application.

  Note: At this time, the script does not automatically restart the updated wowza application, so a subsequent restart must be done via Wowza UI (on a per-application basis) or command line (for an entire Wowza restart).
