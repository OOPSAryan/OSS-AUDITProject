#!/bin/bash
# Master Runner — OSS Audit Project
# Author: Aryan Baghel

set -euo pipefail

# Colors
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="$SCRIPT_DIR/reports"
LOG_FILE="$REPORT_DIR/audit_$(date '+%Y-%m-%d_%H-%M-%S').log"
TOTAL_START=$(date +%s)
FAILED_SCRIPTS=()

mkdir -p "$REPORT_DIR"

# Logging function
log() {
    echo -e "$@" | tee -a "$LOG_FILE"
}

# Run script function
run_script() {
    local NAME="$1"
    local FILE="$2"
    local START END ELAPSED

    log ""
    log "${CYAN}${BOLD}▶ Running $NAME...${RESET}"

    START=$(date +%s)

    # Check file exists
    if [ ! -f "$FILE" ]; then
        log "${RED}✗ File not found: $FILE${RESET}"
        FAILED_SCRIPTS+=("$NAME")
        return
    fi

    # Special handling for Script 4
    if [[ "$FILE" == *"script4_log_analyzer.sh" ]]; then
        log "${YELLOW}Using sample log file...${RESET}"

        echo "error: sample error" > "$SCRIPT_DIR/test.log"
        echo "info: running" >> "$SCRIPT_DIR/test.log"
        echo "warning: memory low" >> "$SCRIPT_DIR/test.log"

        if bash "$FILE" "$SCRIPT_DIR/test.log" error | tee -a "$LOG_FILE"; then
            :
        else
            FAILED_SCRIPTS+=("$NAME")
        fi

    else
        if bash "$FILE" | tee -a "$LOG_FILE"; then
            :
        else
            FAILED_SCRIPTS+=("$NAME")
        fi
    fi

    END=$(date +%s)
    ELAPSED=$((END - START))

    if [[ ! " ${FAILED_SCRIPTS[@]} " =~ " $NAME " ]]; then
        log "${GREEN}✔ $NAME completed in ${ELAPSED}s${RESET}"
    else
        log "${RED}✗ $NAME failed in ${ELAPSED}s${RESET}"
    fi
}

# Header
log "${CYAN}${BOLD}"
log "╔══════════════════════════════════════════════╗"
log "║       Open Source Audit Project              ║"
log "║            Master Execution Runner           ║"
log "╚══════════════════════════════════════════════╝"
log "${RESET}"

log "Audit started: $(date '+%A, %d %B %Y — %H:%M:%S')"
log "Report file : $LOG_FILE"

# Check Git (only check, no install for Windows)
log ""
log "Checking Git installation..."

if command -v git &>/dev/null; then
    log "${GREEN}✔ Git is installed: $(git --version)${RESET}"
else
    log "${YELLOW}⚠ Git not found (install manually if needed)${RESET}"
fi

# Permissions
chmod +x "$SCRIPT_DIR"/script*.sh 2>/dev/null || true

# Run scripts
run_script "Script 1 — System Identity" "$SCRIPT_DIR/script1_system_identity.sh"
run_script "Script 2 — Package Inspector" "$SCRIPT_DIR/script2_package_inspector.sh"
run_script "Script 3 — Disk Auditor" "$SCRIPT_DIR/script3_disk_auditor.sh"
run_script "Script 4 — Log Analyzer" "$SCRIPT_DIR/script4_log_analyzer.sh"
run_script "Script 5 — Manifesto" "$SCRIPT_DIR/script5_manifesto.sh"

# Summary
TOTAL_END=$(date +%s)
TOTAL_ELAPSED=$((TOTAL_END - TOTAL_START))

log ""
log "${CYAN}${BOLD}══════════════════════════════════════════════${RESET}"
log "${BOLD}Audit Summary${RESET}"
log "Total time : ${TOTAL_ELAPSED}s"
log "Report saved : $LOG_FILE"

if [ ${#FAILED_SCRIPTS[@]} -eq 0 ]; then
    log "${GREEN}✔ All scripts executed successfully!${RESET}"
else
    log "${RED}✗ Failed scripts:${RESET}"
    for F in "${FAILED_SCRIPTS[@]}"; do
        log " - $F"
    done
fi

log "${CYAN}${BOLD}══════════════════════════════════════════════${RESET}"
