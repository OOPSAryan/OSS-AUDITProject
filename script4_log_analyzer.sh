#!/bin/bash

# =============================================================
# Script 4: Log File Analyzer
# Author: Aryan Baghel
# =============================================================

# --- Arguments ---
LOGFILE=$1
KEYWORD=${2:-"error"}

COUNT=0

echo "================================================================"
echo "              LOG FILE ANALYZER"
echo "================================================================"
echo "  Log file : ${LOGFILE:-[not specified]}"
echo "  Keyword  : $KEYWORD"
echo "----------------------------------------------------------------"

# --- Check input ---
if [ -z "$LOGFILE" ]; then
    echo "[ERROR] No log file specified."
    echo "Usage: $0 <logfile> [keyword]"
    exit 1
fi

# --- Retry logic ---
MAX_RETRIES=3
RETRY=0

while true; do

    if [ ! -f "$LOGFILE" ]; then
        echo "[ERROR] File not found: $LOGFILE"
        RETRY=$((RETRY + 1))

        if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
            echo "[FAIL] File not found after $MAX_RETRIES attempts."
            exit 1
        fi

        echo "[RETRY $RETRY/$MAX_RETRIES] Waiting..."
        sleep 2
        continue
    fi

    if [ ! -s "$LOGFILE" ]; then
        echo "[WARN] File is empty: $LOGFILE"
        RETRY=$((RETRY + 1))

        if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
            echo "[FAIL] File still empty after retries."
            exit 1
        fi

        echo "[RETRY $RETRY/$MAX_RETRIES] Retrying..."
        sleep 2
        continue
    fi

    break
done

echo "[OK] File found. Scanning..."
echo ""

# --- Read file ---
while IFS= read -r LINE; do
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
    fi
done < "$LOGFILE"

# --- Output ---
echo "  Total lines scanned : $(wc -l < "$LOGFILE")"
echo "  Keyword '$KEYWORD'  : found $COUNT time(s)"
echo ""

echo "----------------------------------------------------------------"
echo "  Last 5 lines containing '$KEYWORD':"
echo "----------------------------------------------------------------"

MATCHES=$(grep -i "$KEYWORD" "$LOGFILE" | tail -5)

if [ -n "$MATCHES" ]; then
    while IFS= read -r LINE; do
        echo "  >> $LINE"
    done <<< "$MATCHES"
else
    echo "  [NONE] No matches found."
fi

echo "================================================================"
