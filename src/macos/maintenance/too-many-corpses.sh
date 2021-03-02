#!/bin/bash

# Use this script if you encounter the "Opendirectoryd too many corpses being created" error on macOS
# This script must be run from a recovery-mode terminal
# Attribution: https://apple.stackexchange.com/questions/322509/opendirectoryd-too-many-corpses-being-created

main() {
    cd /Volumes/Macintosh\ HD/var/db/caches/opendirectory
    mv ./mbr_cache ./mbr_cache-old
    shutdown -r now
}

main
