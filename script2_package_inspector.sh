#!/bin/bash

# =============================================================================
# Script 2: FOSS Package Inspector
# Author: Aryan Baghel
# Registration No: 24BCE11101
# =============================================================================

# --- Variables ---
PACKAGE="python3"
AUTHOR="Aryan Baghel"
REG_NO="24BCE11101"

# --- Header ---
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                    FOSS PACKAGE INSPECTOR                                ║"
echo "║                    Author: $AUTHOR | Reg No: $REG_NO                     ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# --- Function: dpkg check ---
check_dpkg() {
    local pkg=$1
    if dpkg -l | grep -q "^[[:space:]]*ii[[:space:]]*${pkg}"; then
        return 0
    else
        return 1
    fi
}

# --- Function: rpm check ---
check_rpm() {
    local pkg=$1
    if rpm -q "$pkg" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# --- Function: dpkg info ---
get_dpkg_info() {
    local pkg=$1
    echo "--- Package Information (dpkg) ---"
    dpkg -l "$pkg" 2>/dev/null | tail -1 | awk '{print "Package: " $2 "\nVersion: " $3}'
    apt-cache show "$pkg" 2>/dev/null | grep -E "^Description:" | head -1
}

# --- Function: rpm info ---
get_rpm_info() {
    local pkg=$1
    echo "--- Package Information (rpm) ---"
    rpm -qi "$pkg" 2>/dev/null | grep -E "Name|Version|License|Summary"
}

# --- Check Installation ---
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checking installation status for: $PACKAGE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v dpkg &>/dev/null; then
    PKG_MANAGER="dpkg"
    if check_dpkg "$PACKAGE"; then
        INSTALLED=true
    else
        INSTALLED=false
    fi

elif command -v rpm &>/dev/null; then
    PKG_MANAGER="rpm"
    if check_rpm "$PACKAGE"; then
        INSTALLED=true
    else
        INSTALLED=false
    fi

else
    PKG_MANAGER="command"
    if command -v "$PACKAGE" &>/dev/null; then
        INSTALLED=true
    else
        INSTALLED=false
    fi
fi

# --- Output ---
if [ "$INSTALLED" = true ]; then
    echo "✓ $PACKAGE is INSTALLED on this system"
    echo ""

    case $PKG_MANAGER in
        dpkg)
            get_dpkg_info "$PACKAGE"
            ;;
        rpm)
            get_rpm_info "$PACKAGE"
            ;;
        command)
            echo "--- Package Information ---"
            echo "Command path: $(which $PACKAGE)"
            $PACKAGE --version 2>&1 | head -3
            ;;
    esac

else
    echo "✗ $PACKAGE is NOT INSTALLED"
fi

# --- Philosophy ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "FOSS PHILOSOPHY CORNER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

case "$PACKAGE" in
    python|python3)
        echo "🐍 Python: Simple is better than complex."
        ;;
    git)
        echo "📦 Git: Built by Linus Torvalds for open development."
        ;;
    firefox)
        echo "🦊 Firefox: Privacy-first open web browser."
        ;;
    *)
        echo "❓ Every open-source project has a story."
        ;;
esac

# --- Loop Example ---
echo ""
echo "Additional Notes:"
for pkg in git firefox vlc; do
    case $pkg in
        git) echo "• Git: Version control freedom" ;;
        firefox) echo "• Firefox: Open web" ;;
        vlc) echo "• VLC: Free media player" ;;
    esac
done

# --- End ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Completed at $(date '+%H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 0
