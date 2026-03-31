#!/bin/bash

# =============================================================================
# Script 3: Disk and Permission Auditor
# Author: Aryan Baghel
# Registration No: 24BCE11101
# =============================================================================

AUTHOR="Aryan Baghel"
REG_NO="24BCE11101"
SOFTWARE="Python"

# --- Header ---
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    DISK AND PERMISSION AUDITOR                            ║"
echo "║                    Author: $AUTHOR | Reg No: $REG_NO                     ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# --- Directories ---
SYSTEM_DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/local" "/opt")

# --- Function ---
get_dir_info() {
    local dir=$1

    if [ ! -d "$dir" ]; then
        echo "❌ $dir does not exist"
        return
    fi

    perms=$(ls -ld "$dir" | awk '{print $1}')
    owner=$(ls -ld "$dir" | awk '{print $3}')
    group=$(ls -ld "$dir" | awk '{print $4}')
    size=$(du -sh "$dir" 2>/dev/null | cut -f1)

    if [ -z "$size" ]; then
        size="Access Denied"
    fi

    printf "%-15s | %-10s | %-8s | %-8s | %s\n" "$dir" "$size" "$owner" "$group" "$perms"
}

# --- Section 1 ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 1: SYSTEM DIRECTORY AUDIT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Directory       | Size       | Owner    | Group    | Permissions"
echo "--------------------------------------------------------------------------"

for DIR in "${SYSTEM_DIRS[@]}"; do
    get_dir_info "$DIR"
done

# --- Section 2 ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 2: PYTHON DIRECTORIES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PYTHON_DIRS=(
"/usr/lib/python3"
"/usr/local/lib/python3"
"$HOME/.local/lib/python"
"$HOME/.local/bin"
)

echo "Directory                       | Size       | Owner:Group | Permissions"
echo "--------------------------------------------------------------------------"

for DIR in "${PYTHON_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        perms=$(ls -ld "$DIR" | awk '{print $1}')
        owner=$(ls -ld "$DIR" | awk '{print $3}')
        group=$(ls -ld "$DIR" | awk '{print $4}')
        size=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        printf "✓ %-30s | %-10s | %s:%s | %s\n" "$DIR" "$size" "$owner" "$group" "$perms"
    else
        printf "✗ %-30s | Not found\n" "$DIR"
    fi
done

# --- Section 3 ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 3: PYTHON EXECUTABLES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PYTHON_EXECUTABLES=("python" "python3" "pip" "pip3")

echo "Executable      | Location                           | Permissions"
echo "--------------------------------------------------------------------------"

for EXEC in "${PYTHON_EXECUTABLES[@]}"; do
    if command -v "$EXEC" &>/dev/null; then
        location=$(which "$EXEC")

        if [ -f "$location" ]; then
            perms=$(ls -l "$location" | awk '{print $1}')
            printf "%-15s | %-35s | %s\n" "$EXEC" "$location" "$perms"
        else
            printf "%-15s | %-35s | alias/function\n" "$EXEC" "$location"
        fi
    else
        printf "%-15s | Not installed\n" "$EXEC"
    fi
done

# --- Section 4 ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 4: DISK SPACE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

df -h

# --- Section 5 ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SECTION 5: SECURITY CHECK"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

WORLD_WRITABLE=0

for DIR in "${SYSTEM_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        perms=$(ls -ld "$DIR" | awk '{print $1}')

        if [[ "${perms:8:1}" == "w" ]]; then
            echo "⚠️  $DIR may be world-writable: $perms"
            ((WORLD_WRITABLE++))
        fi
    fi
done

echo ""
echo "Checking /tmp:"
ls -ld /tmp

if [ $WORLD_WRITABLE -eq 0 ]; then
    echo "✓ No risky directories found"
fi

# --- End ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Audit completed at $(date '+%H:%M:%S on %d/%m/%Y')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 0
