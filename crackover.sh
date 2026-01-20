#!/usr/bin/env bash

set -euo pipefail  # exit on errors, undefined vars, bad pipe returns

# Check/install pidof if missing (optional – pgrep usually works fine on macOS)
if ! command -v pidof >/dev/null 2>&1; then
    echo "Installing pidof via brew..."
    brew install pidof || { echo "brew install failed – continuing without pidof"; }
fi

# Find CrossOver binary path
CO_PWD=~/Applications/CrossOver.app/Contents/MacOS
[[ -d "$CO_PWD" ]] || CO_PWD=/Applications/CrossOver.app/Contents/MacOS

if [[ ! -d "$CO_PWD" ]]; then
    echo "Could not find CrossOver.app in ~/Applications or /Applications. Exiting."
    exit 1
fi

cd "$CO_PWD" || exit 1

PROC_NAME="CrossOver"

# Collect PIDs (using safer methods)
pids=()
while IFS= read -r pid; do [[ $pid =~ ^[0-9]+$ ]] && pids+=("$pid"); done < <(pgrep "$PROC_NAME")
while IFS= read -r pid; do [[ $pid =~ ^[0-9]+$ ]] && pids+=("$pid"); done < <(pidof "$PROC_NAME" 2>/dev/null)
# Last fallback – usually not needed
ps -Ac | grep -m1 "$PROC_NAME" | awk '{print $1}' | while read -r pid; do pids+=("$pid"); done

# Remove duplicates and kill
if [[ ${#pids[@]} -gt 0 ]]; then
    printf "Killing CrossOver processes: %s\n" "${pids[*]}"
    kill -9 "${pids[@]}" 2>/dev/null || true
    sleep 4
fi

# Set date to 3 hours ago (UTC, RFC3339)
DATETIME=$(date -u -v-3H '+%Y-%m-%dT%TZ')
echo "Setting trial dates to: $DATETIME"

plutil -replace FirstRunDate  -date "$DATETIME" ~/Library/Preferences/com.codeweavers.CrossOver.plist
plutil -replace SULastCheckTime -date "$DATETIME" ~/Library/Preferences/com.codeweavers.CrossOver.plist

osascript -e "display notification \"Trial dates reset to $DATETIME\" with title \"CrossOver Fix\""

# Clean [Software\CodeWeavers\CrossOver\cxoffice] sections from system.reg
# Use correct escaping for BSD sed
find ~/Library/Application\ Support/CrossOver/Bottles -type f -name system.reg -print0 | while IFS= read -r -d '' file; do
    sed -i '' '/^\[Software\\CodeWeavers\\CrossOver\\cxoffice\]/,+6d' "$file"
done

# Remove .update-timestamp files (and optionally .eval if present)
find ~/Library/Application\ Support/CrossOver/Bottles -type f \( -name ".update-timestamp" -o -name ".eval" \) -delete

osascript -e 'display notification "Bottles cleaned – timestamps & eval files removed" with title "CrossOver Fix"'

# Launch original binary (assuming you renamed it to CrossOver.origin)
echo "Launching: $CO_PWD/CrossOver.origin"
"$CO_PWD/CrossOver.origin" >> /tmp/co_log.log 2>&1
